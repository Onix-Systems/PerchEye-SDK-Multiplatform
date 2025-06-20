#import "PerchEyeBridge.h"
#import "ImageToVector.hpp"
#import "perch_eye_core.h"

using namespace std;

#define MODEL_SIZE 160

@implementation PerchEyeBridge

- (void)perchInit {
    NSLog(@"[PerchEyeBridge perchInit] called!");
    perchInit();
}

- (void)destroy {
    NSLog(@"[PerchEyeBridge perchDestroy] called!");
    perchDestroy();
}

- (void)openTransaction {
    NSLog(@"[PerchEyeBridge perchOpenTransaction] called!");
    perchOpenTransaction();
}

- (ImageResult)loadImage:(UIImage *)image {
    NSLog(@"[PerchEyeBridge perchLoadImage] called!");
    
    int width = 0;
    int height = 0;
    std::vector<uint8_t> vectorArray = [ImageToVector UIImageToByteVector:image
                                                                    width:width
                                                                   height:height];
    int result = perchLoadImage(vectorArray, width, height);
    
    switch (result) {
        case ImageResultSuccess:
            return ImageResultSuccess;
        case ImageResultFaceNotFound:
            return ImageResultFaceNotFound;
        case ImageResultTransactionNotOpened:
            return ImageResultTransactionNotOpened;
        case ImageResultSDKNotInitialized:
            return ImageResultSDKNotInitialized;
        default:
            return ImageResultInternalError;
    }
}

- (float)verify:(NSString *)hash {
    return perchExecuteVerify([self decodeHash:hash]);
}

- (NSString *)enroll {
    std::vector<std::vector<float>> result = perchExecuteEnroll();
    
    NSArray<NSArray<NSNumber *> *> *features = [self convertCppFeatures:result];
    return [self encodeHashWithFeatures:features];
}

- (NSData *)rgba8888DataFromImage:(UIImage *)image {
    const size_t modelSize = MODEL_SIZE;
    const size_t width = modelSize;
    const size_t height = modelSize;
    const size_t bytesPerPixel = 4;
    const size_t bytesPerRow = bytesPerPixel * width;
    const size_t bitsPerComponent = 8;

    // Resize UIImage to exact model size (160x160)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRef imageRef = resizedImage.CGImage;

    NSMutableData *rawData = [NSMutableData dataWithLength:bytesPerRow * height];
    void *buffer = rawData.mutableBytes;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Use non-premultiplied alpha, and little-endian byte order
    CGContextRef context = CGBitmapContextCreate(buffer,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);

    if (!context) {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return rawData;
}

- (NSArray<NSArray<NSNumber *> *> *)evaluateRGBAImages:(NSArray<NSData *> *)rgbaImageDataArray {
    std::vector<std::vector<uint8_t>> input;
    for (NSData *data in rgbaImageDataArray) {
        input.emplace_back((uint8_t *)data.bytes, (uint8_t *)data.bytes + data.length);
    }

    std::vector<std::vector<float>> result = perchEvaluate(input);

    return [self convertCppFeatures:result];
}

- (NSArray<NSArray<NSNumber *> *> *)convertCppFeatures:(const std::vector<std::vector<float>> &)features {
    NSMutableArray<NSArray<NSNumber *> *> *objcArray = [NSMutableArray arrayWithCapacity:features.size()];
    
    for (const auto &row : features) {
        NSMutableArray<NSNumber *> *objcRow = [NSMutableArray arrayWithCapacity:row.size()];
        for (float value : row) {
            [objcRow addObject:@(value)];
        }
        [objcArray addObject:objcRow];
    }
    
    return [objcArray copy];
}

- (float)compareRGBAImages:(NSArray<NSData *> *)rgbaImages
                  withHash:(NSArray<NSArray<NSNumber *> *> *)hash {

    std::vector<std::vector<uint8_t>> imageData;
    for (NSData *data in rgbaImages) {
        std::vector<uint8_t> img((uint8_t *)data.bytes, (uint8_t *)data.bytes + data.length);
        imageData.push_back(std::move(img));
    }

    std::vector<std::vector<float>> hashData;
    for (NSArray<NSNumber *> *row in hash) {
        std::vector<float> rowVec;
        for (NSNumber *val in row) {
            rowVec.push_back(val.floatValue);
        }
        hashData.push_back(std::move(rowVec));
    }

    float score = perchCompare(imageData, hashData);
    return score;
}

- (NSString *)encodeHashWithFeatures:(NSArray<NSArray<NSNumber *> *> *)features {
    if (features.count == 0) return @"";

    int32_t rows = (int32_t)features.count;
    int32_t cols = (int32_t)features[0].count;

    NSMutableData *buffer = [NSMutableData dataWithCapacity:8 + rows * cols * sizeof(float)];

    int32_t rowsBE = CFSwapInt32HostToBig(rows);
    int32_t colsBE = CFSwapInt32HostToBig(cols);
    [buffer appendBytes:&rowsBE length:4];
    [buffer appendBytes:&colsBE length:4];

    for (NSArray<NSNumber *> *row in features) {
        for (NSNumber *val in row) {
            float f = [val floatValue];
            uint32_t bits;
            memcpy(&bits, &f, sizeof(float));
            bits = CFSwapInt32HostToBig(bits); // Correct endian swap
            [buffer appendBytes:&bits length:sizeof(bits)];
        }
    }

    return [buffer base64EncodedStringWithOptions:0];
}

- (std::vector<std::vector<float>>)decodeHash:(NSString *)hash {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:hash options:0];
        if (!data) return {};

        const uint8_t *bytes = (const uint8_t *)[data bytes];
        NSUInteger length = [data length];
        NSUInteger offset = 0;

        if (length < 8) return {};

        int32_t rows, cols;
        memcpy(&rows, bytes + offset, 4);
        rows = CFSwapInt32BigToHost(rows);
        offset += 4;

        memcpy(&cols, bytes + offset, 4);
        cols = CFSwapInt32BigToHost(cols);
        offset += 4;

        if (length < offset + rows * cols * sizeof(uint32_t)) return {};

        std::vector<std::vector<float>> decodedHash(rows, std::vector<float>(cols));

        for (int i = 0; i < rows; ++i) {
            for (int j = 0; j < cols; ++j) {
                uint32_t bits;
                memcpy(&bits, bytes + offset, sizeof(uint32_t));
                bits = CFSwapInt32BigToHost(bits); // endian fix
                float value;
                memcpy(&value, &bits, sizeof(float));
                decodedHash[i][j] = value;
                offset += sizeof(uint32_t);
            }
        }

        return decodedHash;
}

-(void)encodeHash {
    
}

// MARK: - Compare Images
- (float)compareImages:(NSArray<UIImage *> *)images withHash:(NSString *)hashString {
    NSInteger modelSize = MODEL_SIZE;
    
    if (![self areBitmapsValid:images modelSize:modelSize]) {
        return 0.0f;
    }

    // Convert UIImages to RGBA 8888 buffers
    NSMutableArray<NSData *> *flattenedImages = [NSMutableArray array];
    for (UIImage *image in images) {
        NSData *rgbaData = [self rgba8888DataFromImage:image];
        if (rgbaData.length != modelSize * modelSize * 4) {
            return 0.0f; // image data mismatch
        }
        [flattenedImages addObject:rgbaData];
    }

    @try {
        
        NSArray<NSArray<NSNumber *> *> *decodedHash = [self convertCppFeatures:[self decodeHash:hashString]];
        return [self compareRGBAImages:flattenedImages withHash:decodedHash];
    } @catch (NSException *exception) {
        return 0.0f;
    }
}

// MARK: - Evaluate Images
- (NSString *)evaluateWithImages:(NSArray<UIImage *> *)images {
    NSInteger modelSize = MODEL_SIZE;
    
    if (![self areBitmapsValid:images modelSize:modelSize]) {
        return @"";
    }

    NSMutableArray<NSData *> *flattenedImages = [NSMutableArray array];
    for (UIImage *image in images) {
        NSData *rgbaData = [self rgba8888DataFromImage:image];
        if (rgbaData.length != modelSize * modelSize * 4) {
            return @""; // invalid
        }
        
//        [self debugPrintFirstBytes:rgbaData label:@"Image RGBA"];
        
        [flattenedImages addObject:rgbaData];
    }

    NSArray<NSArray<NSNumber *> *> *features = [self evaluateRGBAImages:flattenedImages];
    return [self encodeHashWithFeatures:features];
}

// MARK: - Helper

- (BOOL)areBitmapsValid:(NSArray<UIImage *> *)images modelSize:(NSInteger)modelSize {
    for (UIImage *image in images) {
        CGImageRef cgImage = image.CGImage;
        if (!cgImage) return NO;
        
        if (CGImageGetWidth(cgImage) != modelSize ||
            CGImageGetHeight(cgImage) != modelSize) {
            return NO;
        }
        
        // Check pixel format (simplified: assume ARGB_8888 is CGImage with 8 bits per component and 4 components)
        size_t bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
        if (bitsPerComponent != 8 || bitsPerPixel != 32) {
            return NO;
        }
    }
    return YES;
}

- (NSMutableArray<NSNumber *> *)extractPixelsFromImage:(UIImage *)image {
    CGImageRef cgImage = image.CGImage;
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * width;
    size_t bitsPerComponent = 8;

    NSMutableArray<NSNumber *> *pixels = [NSMutableArray arrayWithCapacity:width * height];
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 CGImageGetColorSpace(cgImage),
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);

    if (!context) return pixels;

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    UInt32 *data = (UInt32 *)CGBitmapContextGetData(context);

    for (int i = 0; i < width * height; i++) {
        [pixels addObject:@(data[i])];
    }

    CGContextRelease(context);
    return pixels;
}

// MARK: - Debug methods
- (void)debugPrintFirstBytes:(NSData *)data label:(NSString *)label {
    const unsigned char *bytes = (const unsigned char *)[data bytes];
    NSMutableString *output = [NSMutableString stringWithFormat:@"%@: ", label];
    for (NSUInteger i = 0; i < MIN(32, data.length); ++i) {
        [output appendFormat:@"%02X ", bytes[i]];
    }
    NSLog(@"%@", output);
}

@end
