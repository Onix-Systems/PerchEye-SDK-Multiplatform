# PerchEye iOS Integration Guide

This project demonstrates the integration and usage of PerchEye Framework for face recognition and comparison in iOS applications.

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+

## Library Integration

### 1. Adding PerchEye Framework

1. Download PerchEye Framework from the official source
2. Drag `PerchEyeFramework.xcframework` into your Xcode project
3. Ensure the framework is added to `Frameworks, Libraries, and Embedded Content`
4. Set `Embed & Sign` for the framework

### 2. Permissions Setup

Add photo library access permission to `Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>App needs access to photos for face analysis</string>
```

## Basic Usage

### 1. Import Library

```swift
import PerchEyeFramework
```

### 2. Create Face Analyzer

```swift
class FacesAnalyzer {
    private let perchEye: PerchEyeSwift
    
    init() {
        perchEye = PerchEyeSwift()
    }
}
```

### 3. Analyze Images

```swift
func analyzeFaces(in firstImages: [UIImage], and secondImages: [UIImage]) async throws -> Float {
    return try await withCheckedThrowingContinuation { continuation in
        do {
            // Open transaction for first image group
            perchEye.openTransaction()
            let firstHash = try generateHash(for: firstImages)
            
            // Open transaction for second image group
            perchEye.openTransaction()
            try loadImages(for: secondImages)
            
            // Compare images
            let similarity = perchEye.verify(hash: firstHash)
            
            continuation.resume(returning: similarity)
        } catch {
            continuation.resume(throwing: error)
        }
    }
}
```

### 4. Handle Results

```swift
func compareImages() async {
    do {
        let score = try await facesAnalyzer.analyzeFaces(in: firstImages, and: secondImages)
        
        // Compare with similarity threshold
        let threshold: Float = 0.8
        if score > threshold {
            print("Faces are similar: \(score)")
        } else {
            print("Faces are different: \(score)")
        }
    } catch {
        print("Analysis error: \(error)")
    }
}
```

## Key Components

### FacesAnalyzer
Main class for working with PerchEye SDK:
- `analyzeFaces()` - compare two groups of images
- `generateHash()` - generate hash for images
- `loadImages()` - load images for analysis

### Error Handling
```swift
struct CustomError: Error, LocalizedError, Identifiable {
    let id = UUID()
    let title: String
    let message: String
}
```

Common errors:
- `sdkNotInitialized` - SDK not initialized
- `faceNotFound` - Face not found in image
- `transactionNotOpened` - Transaction not opened
- `internalError` - Internal SDK error

### UI Components

#### PhotoFolderView
Component for photo selection:
```swift
PhotoFolderView(
    images: $viewModel.firstImagesGroup,
    selectedItems: $firstSelectedItems,
    isPresented: $showFirstPhotoPicker
)
```

#### Result Display
```swift
Text(String(format: "%.2f", score))
    .foregroundColor(score > threshold ? .green : .red)
```

## SwiftUI Usage Example

```swift
struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            // Photo selection UI
            HStack {
                PhotoFolderView(images: $viewModel.firstImagesGroup, ...)
                PhotoFolderView(images: $viewModel.secondImagesGroup, ...)
            }
            
            // Compare button
            Button("Compare Photos") {
                Task {
                    await viewModel.compareImages()
                }
            }
            
            // Result display
            if let score = viewModel.similarityScore {
                Text("Similarity: \(String(format: "%.2f", score))")
            }
        }
        .errorAlert($viewModel.error)
    }
}
```

## Usage Tips

1. **Image Quality**: Use images with clearly visible faces
2. **Lighting**: Avoid images with poor lighting conditions
3. **Face Count**: Image should contain only one face
4. **Similarity Threshold**: Recommended threshold of 0.8 for accurate recognition
5. **Error Handling**: Always handle cases when face is not found

## License

Check PerchEye Framework license terms before using in commercial projects.