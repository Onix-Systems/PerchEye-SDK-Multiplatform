# PerchEye Flutter SDK – Dart API Reference

This class provides a high-level Dart interface for accessing native face recognition functionality through platform channels using the PerchEye Android SDK.

---

## 🔌 Class: `PerchEye`

### 📡 Channel

```dart
static const MethodChannel _channel = MethodChannel('perch_eye_method_channel');
```

> Internal method channel used for native communication (do not modify).

---

## 🧹 Methods

### `Future<void> init()`

Initializes the underlying PerchEye native SDK.
Must be called **once before** any recognition-related operations.

```dart
await PerchEye.init();
```

---

### `Future<void> destroy()`

Releases SDK resources and unloads the model.
Call this when the app or session ends.

```dart
await PerchEye.destroy();
```

---

### `Future<void> openTransaction()`

Opens a new session for face processing.
This is required **before** `addImage()`.

```dart
await PerchEye.openTransaction();
```

---

### `Future<String> addImage(String base64)`

Adds a face image to the current transaction for processing.
Accepts a base64-encoded image string.

Returns:

* A string representing the result enum (`SUCCESS`, `FACE_NOT_FOUND`, etc.)

```dart
final result = await PerchEye.addImage(base64Image);
if (result == 'SUCCESS') {
  // Proceed with enroll or verify
}
```

---

### `Future<String> enroll()`

Generates a Base64-encoded face embedding hash from the previously added image.

Returns:

* A `String` face hash

```dart
await PerchEye.openTransaction();
await PerchEye.addImage(base64Image);
final hash = await PerchEye.enroll();
```

---

### `Future<double> verify(String hash)`

Verifies the last added image against a given face hash.

Returns:

* Similarity score (`0.0` to `1.0`)

```dart
await PerchEye.openTransaction();
await PerchEye.addImage(base64Image);
final similarity = await PerchEye.verify(hash);
```

---

### `Future<String> evaluate(List<String> base64Images)`

Evaluates multiple images to produce a single aggregated face hash.

Returns:

* Combined hash as `String`

```dart
final hash = await PerchEye.evaluate([base64Image1, base64Image2]);
```

---

### `Future<double> compareList(List<String> images, String hash)`

Compares a list of base64-encoded images against a face hash.

Returns:

* Similarity score (`0.0` to `1.0`)

```dart
final sim = await PerchEye.compareList(
  [base64Image1, base64Image2],
  knownHash,
);
```

---

### `Future<double> compareFaces(String base64_1, String base64_2)`

Convenience method:
Internally performs:

* `openTransaction()`
* `addImage(image1)` → `enroll()` → `openTransaction()` → `addImage(image2)` → `verify()`

Returns:

* Similarity score (`0.0` to `1.0`)

```dart
final similarity = await PerchEye.compareFaces(base64Image1, base64Image2);
```

---

## 🧪 Example Workflow

```dart
await PerchEye.init();

await PerchEye.openTransaction();
await PerchEye.addImage(base64Image1);
final hash = await PerchEye.enroll();

await PerchEye.openTransaction();
await PerchEye.addImage(base64Image2);
final similarity = await PerchEye.verify(hash);

await PerchEye.destroy();
```

---