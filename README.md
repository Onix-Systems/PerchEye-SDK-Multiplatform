---
# PerchEye Multiplatform SDK
Full reference and usage guide for the PerchEye facial recognition SDK across Android, iOS, Flutter, and React Native platforms.
---

# PerchEye Multiplatform SDK

PerchEye SDK provides advanced facial recognition functionality for mobile applications across multiple platforms, enabling face detection, enrollment, verification, and comparison using embedded TensorFlow Lite models.

## 🚀 Supported Platforms

- **Android** - Native Android SDK with Kotlin/Java support
- **iOS** - Native iOS SDK with Swift/Objective-C support
- **Flutter** - Dart plugin for cross-platform Flutter applications
- **React Native** - JavaScript/TypeScript module for React Native apps

## 📦 Platform-Specific Documentation

### [Android SDK](android-aar/README.md)
- **Location**: `/android-aar/`
- **Language**: Kotlin/Java
- **Integration**: Gradle dependency
- **Documentation**: Native Android implementation

### [iOS SDK](ios/README.md)
- **Location**: `/ios/`
- **Language**: Swift/Objective-C
- **Integration**: CocoaPods/Swift Package Manager
- **Documentation**: Native iOS implementation

### [Flutter Plugin](flutter/README.md)
- **Location**: `/flutter/`
- **Language**: Dart
- **Integration**: pub.dev dependency
- **Documentation**: Cross-platform Flutter plugin

### [React Native Module](react-native/README.md)
- **Location**: `/react-native/`
- **Language**: JavaScript/TypeScript
- **Integration**: npm package
- **Documentation**: Cross-platform React Native module

## 🔧 Quick Start Examples

### Android (Kotlin)
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

### iOS (Swift)
```swift
let perchEye = PerchEyeSwift()
perchEye.openTransaction()

let result = perchEye.load(image: uiImage)
if result == .success {
    let hash = perchEye.enroll()
    let similarity = perchEye.verify(hash: hash)
}

perchEye.destroy()
```

### Flutter (Dart)
```dart
await PerchEye.init();
await PerchEye.openTransaction();

final result = await PerchEye.addImage(base64Image);
if (result == 'SUCCESS') {
    final hash = await PerchEye.enroll();
    final similarity = await PerchEye.verify(hash);
}

await PerchEye.destroy();
```

### React Native (JavaScript)
```javascript
import { openTransaction, addImage, enroll, verify } from 'react-native-perch-eye';

await openTransaction();
const result = await addImage(base64Image);
if (result === 'SUCCESS') {
    const hash = await enroll();
    const similarity = await verify(hash);
}
```

## 🎯 Core Features

### Universal Functionality
All platform implementations provide:

- **Face Detection** - Identify human faces in images
- **Face Enrollment** - Generate unique biometric hashes
- **Face Verification** - Compare faces against stored hashes
- **Batch Processing** - Handle multiple images efficiently
- **Offline Operation** - No internet connection required

### ImageResult Status Codes
All platforms return consistent status codes:

- `SUCCESS` - Operation completed successfully
- `FACE_NOT_FOUND` - No face detected in the image
- `FILE_NOT_FOUND` - Image file not found (Android only)
- `TRANSACTION_NOT_OPEN` - No active transaction
- `SDK_NOT_INITIALIZED` - SDK not properly initialized
- `INTERNAL_ERROR` - Internal processing error

## 🔐 Security & Privacy

- **Offline Processing** - All computation happens on-device
- **No Data Transmission** - Biometric data never leaves the device
- **Hash-Based Storage** - Only mathematical representations are stored
- **Privacy Compliant** - Meets GDPR and privacy regulations

## 📱 Demo Applications

Each platform includes a fully functional demo application:

- **[Android Demo](android-demo/README.md)** - `android-demo/` - Native Android app
- **[iOS Demo](ios-demo/README.md)** - `ios-demo/` - Native iOS app
- **[Flutter Demo](flutter-demo/README.md)** - `flutter-demo/` - Cross-platform Flutter app
- **[React Native Demo](react-native-demo/README.md)** - `react-native-demo/` - Cross-platform RN app

## 🛠 Development Setup

### Prerequisites
- **Android**: Android Studio, Gradle, API level 24+
- **iOS**: Xcode 12+, iOS 14.0+, Swift 5.0+
- **Flutter**: Flutter SDK 3.0+, Dart 2.17+
- **React Native**: Node.js 18+, React Native 0.70+

### Building from Source
```bash
# Clone the repository
git clone https://github.com/Onix-Systems/PerchEye-SDK-Multiplatform.git

# Build Android SDK
cd android && ./gradlew build

# Build iOS SDK  
cd ios && xcodebuild -project PerchEyeFramework.xcodeproj

# Build Flutter plugin
cd flutter && flutter packages get

# Build React Native module
cd react-native && npm install
```

## 📊 Performance Characteristics

### Processing Speed
- **Face Detection**: ~50-100ms per image
- **Hash Generation**: ~100-200ms per face
- **Verification**: ~10-50ms per comparison
- **Multi-threading**: Supported on all platforms

### Memory Usage
- **Runtime Memory**: ~50-100MB active usage
- **Model Size**: ~10-20MB embedded model
- **Hash Size**: ~2-5KB per face encoding

### Accuracy Metrics
- **Detection Rate**: >95% for clear frontal faces
- **False Accept Rate**: <0.1% at 0.8 threshold
- **False Reject Rate**: <5% at 0.8 threshold

## 🔧 Integration Guides

### Platform-Specific Setup

#### Android
```gradle
dependencies {
    implementation 'com.percheye.android:sdk:1.2.3'
}
```

#### iOS
```ruby
# Podfile
pod 'PerchEyeFramework', '~> 1.0'
```

#### Flutter
```yaml
# pubspec.yaml
dependencies:
  perch_eye: ^0.0.1
```

#### React Native
```bash
npm install react-native-perch-eye
```

## 🌐 Web Documentation

Visit our comprehensive web documentation at:
- **GitHub Pages**: [https://onix-systems.github.io/PerchEye-SDK-Multiplatform](https://onix-systems.github.io/PerchEye-SDK-Multiplatform)
- **API Reference**: Platform-specific API documentation
- **Integration Examples**: Complete code samples
- **Best Practices**: Performance optimization guides

## 📞 Support & Resources

- **GitHub Issues**: [Report bugs and feature requests](https://github.com/Onix-Systems/PerchEye-SDK-Multiplatform/issues)
- **Documentation**: [Platform-specific guides](docs/)
- **Demo Apps**: Working examples for each platform
- **Community**: Developer community and discussions

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests for any improvements.

---

**Note**: Each platform maintains its own specific documentation and examples. Refer to the individual platform folders for detailed implementation guides and platform-specific features.