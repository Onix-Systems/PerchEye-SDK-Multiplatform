#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageResult) {
    ImageResultSDKNotInitialized = -1,
    ImageResultSuccess = 0,
    ImageResultFaceNotFound = 2,
    ImageResultTransactionNotOpened = 3,
    ImageResultInternalError = 100
};

/// The Objective-C interface to the PerchEye SDK.
///
/// This bridge provides access to core facial recognition functions
/// such as enrollment, verification, and image comparison.
@interface PerchEyeBridge : NSObject

/// Initializes the PerchEye SDK and loads the embedded TensorFlow Lite model.
///
/// You must call this method before using any image-processing functions.
/// Failure to initialize will cause subsequent methods to return errors.
- (void)perchInit;

/// Releases resources and unloads the TensorFlow Lite model.
///
/// Call this when you're done using the SDK to prevent memory leaks.
- (void)destroy;

/// Starts a new transaction session.
///
/// A transaction must be opened before calling `loadImage:`, `verify:`, or `enroll`.
- (void)openTransaction;

/// Loads a single image for processing.
///
/// @param image A `UIImage` containing a recognizable human face.
/// @return An `ImageResult` enum indicating the result of the operation.
- (ImageResult)loadImage:(UIImage *)image;

/// Enrolls the loaded image and returns a Base64-encoded embedding hash.
///
/// This embedding can later be used for verification or comparison.
///
/// @return A Base64-encoded `NSString` representing the face embedding.
- (NSString *)enroll;

/// Verifies the loaded image against a provided Base64-encoded hash.
///
/// Automatically closes the transaction after the operation.
///
/// @param hash A Base64-encoded `NSString` representing the reference embedding.
/// @return A `float` similarity score between 0 (no match) and 1 (perfect match).
- (float)verify:(NSString *)hash;

/// Evaluates a set of images and returns a combined embedding.
///
/// Useful for multi-frame or multi-angle analysis.
///
/// @param images An `NSArray<UIImage *>` of facial images.
/// @return A Base64-encoded embedding representing the group.
- (NSString *)evaluateWithImages:(NSArray<UIImage *> *)images;

/// Compares a set of images against a provided embedding.
///
/// @param images An `NSArray<UIImage *>` to compare.
/// @param hashString A Base64-encoded reference embedding.
/// @return A `float` similarity score between 0 and 1.
- (float)compareImages:(NSArray<UIImage *> *)images withHash:(NSString *)hashString;

@end
