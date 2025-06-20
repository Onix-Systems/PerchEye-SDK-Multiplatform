#!/bin/bash

set -ex  # Print all executed commands and stop on first error

SCHEME="PerchEyeFramework"
FRAMEWORK_NAME="PerchEyeFramework"

ARCHIVE_IOS="./build/PerchEyeSDK-iOS.xcarchive"
ARCHIVE_SIM="./build/PerchEyeSDK-sim.xcarchive"
OUTPUT_XCFRAMEWORK="./build_framework/PerchEyeSDK-iOS.xcframework"

echo "📂 Creating build directory..."
mkdir -p ./build_framework

echo "🧹 Cleaning previous builds..."
rm -rf "./build_framework" "$ARCHIVE_IOS" "$ARCHIVE_SIM" "$OUTPUT_XCFRAMEWORK"

echo "Archiving for iOS device..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_IOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  ENABLE_BITCODE=NO \
  clean \
  build

echo "Archiving for iOS Simulator..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$ARCHIVE_SIM" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  ENABLE_BITCODE=NO \
  clean \
  build

echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$ARCHIVE_IOS/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -framework "$ARCHIVE_SIM/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -output "$OUTPUT_XCFRAMEWORK"
  
  rm -rf "./build/"

echo "✅ XCFramework successfully created at: $OUTPUT_XCFRAMEWORK"
