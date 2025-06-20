//
//  ImageToVector.mm
//  perch-eye-ios
//
//  Created by Sergey Pritula on 26.05.2025.
//

#import "ImageToVector.hpp"

@implementation ImageToVector

+ (std::vector<uint8_t>)UIImageToByteVector:(UIImage *)image
                                     width:(int&)width
                                    height:(int&)height {
    CGImageRef imageRef = image.CGImage;
    if (!imageRef) return {};

    width = (int)CGImageGetWidth(imageRef);
    height = (int)CGImageGetHeight(imageRef);
    const size_t bytesPerPixel = 4;
    const size_t bytesPerRow = bytesPerPixel * width;
    const size_t bitsPerComponent = 8;

    std::vector<uint8_t> pixelData(height * bytesPerRow);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixelData.data(),
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);

    if (!context) {
        NSLog(@"[ERROR] Failed to create CGContext");
        CGColorSpaceRelease(colorSpace);
        return {};
    }

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return pixelData;
}

@end
