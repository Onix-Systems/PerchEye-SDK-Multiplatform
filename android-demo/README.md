# 🧠 Perch Eye SDK Documentation

The **Perch Eye SDK** provides the ability to extract a unique hash from faces recognized in an image sequence, and then verify that hash against another sequence.  
The SDK is built on top of **TensorFlow** and **C++**, with **zero dependencies**, making it fast and efficient for mobile applications.

---

## 🔧 Integration

To include the SDK in your project, add the following line to your app-level `build.gradle`:

```kotlin
implementation(files("libs/perch-eye-1.0.2-3.aar"))
```

---

### 🛠️ Initialization

Create an instance of the SDK and initialize it:

```kotlin
val perchEye = PerchEye(context)
perchEye.init()
```

To clean up resources when no longer needed:

```kotlin
perchEye.destroy()
```

---

## 🚀 Usage

### 🔐 Enroll - Create Hash From Face Images

To create a face hash from a sequence of RGBA `Bitmap` images:

```kotlin
perchEye.openTransaction()
perchEye.addImage(image1)
perchEye.addImage(image2)
// ... more images
val hash = perchEye.enroll()
```

---

### 🧪 Verify - Compare New Face With Stored Hash

To compare a new image sequence against a previously created hash:

```kotlin
perchEye.openTransaction()
perchEye.addImage(image4)
// ... more images
val similarity = perchEye.verify(hash)
```

---

### ⚡ Lightweight Methods (Normalized Input)

These are optimized for small (160x160), preprocessed face bitmaps:

```kotlin
val hash = perchEye.evaluate(images: List<Bitmap>)

val similarity = perchEye.compare(images: List<Bitmap>, hash)
```

---

## ❗ Error Codes

addImage method error codes :

```kotlin
enum class ImageResult {
    SUCCESS,
    FACE_NOT_FOUND,
    FILE_NOT_FOUND,
    TRANSACTION_NOT_OPEN,
    SDK_NOT_INITIALIZED,
    INTERNAL_ERROR
}
```

---

## ✅ Summary

- Minimal, dependency-free Android SDK for face hash comparison.
- Designed for high-performance usage in mobile apps.
- Works with raw and preprocessed face images.
