# PerchEye iOS SDK
Full reference and usage guide for the PerchEye facial recognition SDK for iOS.
---
# PerchEye iOS SDK
PerchEye SDK provides advanced facial recognition functionality for iOS applications, enabling face detection, enrollment, verification, and comparison using embedded TensorFlow Lite models.
## Initialization
Initialize the SDK before performing any operations:
```swift
let perchEye = PerchEyeSwift()
```
Always destroy the SDK instance to free resources when done:
```swift
perchEye = nil || perchEye.destroy()
```
## ImageResult Enum
Represents operation results from image processing methods:
- `Success`: Operation completed successfully.
- `FaceNotFound`: No face detected in the provided image.
- `TransactionNotOpened`: Attempted operation without an open transaction.
- `SDKNotInitialized`: SDK was not initialized properly.
- `InternalError`: An internal error occurred within SDK.
## PerchEye Class Methods
### `init()`
Initializes the PerchEye SDK.
```swift
PerchEyeSwift()
```
### `destroy()`
Frees resources allocated by the SDK.
```swift
perchEye.destroy()
```
### `openTransaction()`
Opens a transaction required before loading or comparing images.
```swift
perchEye.openTransaction()
```
### `func load(image: UIImage) -> ImageResult`
Loads an image into the PerchEye SDK for processing.
```swift
let result: ImageResult = perchEye.load(image: uiImage)
```
### `func verify(hash: String) -> Float`
Verifies an image against a given hash string.
At the end of processing this method, the 'transaction' will be closed.
```swift
let similarity: Float = perchEye.verify(hash: base64Hash)
```
### `func enroll() -> String`
Enrolls the currently loaded image and returns a Base64-encoded hash.
At the end of processing this method, the 'transaction' will be closed.
```swift
let hash: String = perchEye.enroll()
```
### `func evaluate(_ images: [UIImage]) -> String`
Evaluates an array of images and returns a combined Base64-encoded hash.
```swift
let hash: String = perchEye.evaluate(arrayOfImages)
```
### `func compare(images: [UIImage], withHash hash: String) -> Float`
Compares an array of images with a given hash string.
```swift
let similarity = perchEye.compare(images: arrayOfImages, withHash base64Hash)
```
## Usage Example
```swift
let perchEye = PerchEyeSwift()

perchEye.openTransaction()

let result = perchEye.load(image: uiImage)

if (result == .success) {
    let base64Hash = perchEye.enroll()
    let similarity = perchEye.verify(hash: base64Hash)
}

perchEye.destroy()
```
## PerchEyeBridge.h (`PerchEyeBridge`)
- `(void)perchInit` – Loads TFLite model.
- `(void)destroy` – Releases SDK resources.
- `(void)openTransaction` – Starts a new session.
- `(ImageResult)loadImage:(UIImage *)image` – Loads an image through `UIImage`.
- `(NSString *)enroll` – Returns face embeddings.
- `(float)verify:(NSString *)hash` – Computes verification score.
- `(NSString *)evaluateWithImages:(NSArray<UIImage *> *)images` – Returns aggregated embeddings.
- `(float)compareImages:(NSArray<UIImage *> *)images withHash:(NSString *)hashString` – Compares embeddings and returns similarity score.
Ensure proper lifecycle management (`(void)perchInit` and `(void)destroy`) to avoid memory leaks and ensure stable operation.
