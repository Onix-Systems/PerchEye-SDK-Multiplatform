
# 📦 PerchEye Android SDK (Library AAR)

This repository contains the compiled **Android SDK** for **PerchEye** — a fast and lightweight face hashing and verification solution for mobile platforms.

> This library is distributed as an `.aar` file only. No source code is included in this package.


---

````
## 📁 Structure

├── perch-eye-1.0.3-4.aar
├── README.md

````

---

## 📦 Artifact

- **Filename**: `perch-eye-1.0.3-4.aar`  
- **Version**: `1.0.3-4`  
- **Min SDK**: `21`  
- **Architecture**: `arm64-v8a`, `armeabi-v7a`  
- **Dependencies**: None (zero-dependency native core)

---

## 🔧 Integration (Consumer Guide)

To include this SDK in your Android app:

### 1. Copy `.aar` file

Copy `perch-eye-1.0.3-4.aar` into your Android app's `libs/` folder.

### 2. Update `build.gradle`

In your **app-level** `build.gradle`:

```kotlin
repositories {
    flatDir {
        dirs 'libs'
    }
}

dependencies {
    implementation(name: 'perch-eye-1.0.3-4', ext: 'aar')
}
````

> ✅ Ensure `libs/` is in the root of your app module.

---

## 🧠 About PerchEye

PerchEye SDK enables:

* Face hash generation (**enrollment**)
* Face hash verification (**similarity scoring**)
* Lightweight embedding with preprocessed inputs
* Fully native C++ core via JNI
* No runtime dependencies

The SDK powers both Android and Flutter integrations for fast face recognition.

---

## 🔒 License

This library is provided as **precompiled binary-only** for evaluation and integration purposes.
Please refer to your licensing agreement with PerchEye.
