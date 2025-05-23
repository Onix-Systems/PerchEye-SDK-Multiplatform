---
# PerchEye Android SDK
Full reference and usage guide for the PerchEye facial recognition SDK for Android.
---
# PerchEye Android SDK
PerchEye SDK provides advanced facial recognition functionality for Android applications, enabling face detection, enrollment, verification, and comparison using embedded TensorFlow Lite models.
## Initialization
Initialize the SDK before performing any operations:
```kotlin
val perchEye = PerchEye(context)
perchEye.init()
```
Always destroy the SDK instance to free resources when done:
```kotlin
perchEye.destroy()
```
## ImageResult Enum
Represents operation results from image processing methods:
- `SUCCESS`: Operation completed successfully.
- `FACE_NOT_FOUND`: No face detected in the provided image.
- `FILE_NOT_FOUND`: The requested file was not found.
- `TRANSACTION_NOT_OPEN`: Attempted operation without an open transaction.
- `SDK_NOT_INITIALIZED`: SDK was not initialized properly.
- `INTERNAL_ERROR`: An internal error occurred within SDK.
## PerchEye Class Methods
### `init()`
Initializes the PerchEye SDK.
```kotlin
perchEye.init()
```
### `destroy()`
Frees resources allocated by the SDK.
```kotlin
perchEye.destroy()
```
### `openTransaction()`
Opens a transaction required before loading or comparing images.
```kotlin
perchEye.openTransaction()
```
### `addImage(image: Bitmap): ImageResult`
Loads a bitmap image.
```kotlin
val result = perchEye.addImage(bitmap)
```
### `addImage(pixels: ByteArray, width: Int, height: Int): ImageResult`
Loads image from raw RGBA byte array.
```kotlin
val result = perchEye.addImage(pixels, width, height)
```
### `verify(hash: String): Float`
Verifies the currently loaded image(s) against a stored hash.
```kotlin
val similarity = perchEye.verify(hash)
```
### `enroll(): String`
Enrolls the currently loaded image and returns a Base64-encoded hash.
```kotlin
val hash = perchEye.enroll()
```
### `evaluate(images: List<Bitmap>): String`
Evaluates a list of images and returns a combined Base64-encoded hash.
```kotlin
val hash = perchEye.evaluate(listOf(bitmap1, bitmap2))
```
### `compare(images: List<Bitmap>, hash: String): Float`
Compares a list of images against a stored hash.
```kotlin
val similarity = perchEye.compare(listOf(bitmap1, bitmap2), hash)
```
## Usage Example
```kotlin
val perchEye = PerchEye(context)
perchEye.init()
perchEye.openTransaction()
val result = perchEye.addImage(bitmap)
if (result == ImageResult.SUCCESS) {
    val hash = perchEye.enroll()
    val similarity = perchEye.verify(hash)
}
perchEye.destroy()
```
## JNI Interface (`PerchEyeJni`)
- `init(assetManager, filename, inputSize, modelEmbedding)` – Loads TFLite model.
- `destroy()` – Releases SDK resources.
- `openTransaction()` – Starts a new session.
- `loadImage(image)` – Loads image via `Bitmap`.
- `loadRGBAArray(image, width, height)` – Loads image from raw data.
- `executeEnroll()` – Returns face embeddings.
- `executeVerify(hashes)` – Computes verification score.
- `evaluate(images)` – Returns aggregated embeddings.
- `compare(images, hashes)` – Compares embeddings and returns similarity score.
Ensure proper lifecycle management (`init()` and `destroy()`) to avoid memory leaks and ensure stable operation.
