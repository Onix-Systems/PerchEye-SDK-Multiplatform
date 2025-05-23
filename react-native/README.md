# 🧠 Perch Eye SDK React Native Documentation

The **Perch Eye SDK** for React Native allows you to extract unique face hashes from image sequences and verify them against new images. The SDK is built using TensorFlow and C++ and provides high performance for mobile applications, with zero dependencies.

---

## 🔧 Integration

Install the native module:

```bash
npm install react-native-perch-eye
```

---

## 🔧 Initialization

```ts
import { init, destroy } from 'react-native-perch-eye';

await init();      // Init native engine
await destroy();   // Cleanup
```
Note: These methods are called natively by the module lifecycle, so manual calls are usually not required.


---

## 🚀 Usage

### 🔐 Enroll - Create Hash From Face Images

To create a face hash from a sequence of base64 images:

```ts
import { openTransaction, addImage, enroll } from 'react-native-perch-eye';

await openTransaction();
await addImage(base64Image1);
await addImage(base64Image2);
// ...
const hash = await enroll();
```

---

### 🧪 Verify - Compare New Face With Stored Hash

To compare a new image sequence against a previously created hash:

```ts
import { openTransaction, addImage, verify } from 'react-native-perch-eye';

await openTransaction();
await addImage(base64ImageNew);
// ...
const similarity = await verify(hash);
```

---

### ⚡ Compare a list

Compares a list of base64-encoded images against a face hash.

```ts
import { evaluate, compareList } from 'react-native-perch-eye';

const hash = await evaluate(base64Images);
const similarity = await compareList(base64Images, hash);
```

---

### ⚡ Optional: Direct Face Comparison

Convenience method:
Internally performs:

* `openTransaction()`
* `addImage(image1)` → `enroll()` → `openTransaction()` → `addImage(image2)` → `verify()`

```ts
import { compareFaces } from 'react-native-perch-eye';

const sim = await compareFaces(img1, img2);
```

---

## ❗ Error Codes

addImage method error codes :

```ts
// Returned string:
"SUCCESS" |
"FACE_NOT_FOUND" |
"FILE_NOT_FOUND" |
"TRANSACTION_NOT_OPEN" |
"SDK_NOT_INITIALIZED" |
"INTERNAL_ERROR"
```

---

## ✅ Summary
- Minimal, high-performance Flutter SDK for face hash comparison.
- Zero dependencies, designed for mobile applications.
- Works with both base64 and raw RGBA face images.
- Includes methods for enrolling, verifying, and comparing face hashes.
