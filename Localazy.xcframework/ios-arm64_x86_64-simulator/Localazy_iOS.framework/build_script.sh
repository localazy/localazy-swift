#! /bin/sh

ARCHIVES_DIR="./archives"
BUILD_DIR="./build"

# Cleanup
rm -rf $ARCHIVES_DIR
rm -rf $BUILD_DIR

# Build for iOS devices
xcodebuild archive \
    -scheme Localazy-iOS \
    -sdk iphoneos \
    -archivePath "$ARCHIVES_DIR/ios_devices.xcarchive" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO

# Build for iOS simulators
xcodebuild archive \
    -scheme Localazy-iOS \
    -sdk iphonesimulator \
    -archivePath "$ARCHIVES_DIR/ios_simulators.xcarchive" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO

# Build for macOS (x86 and ARM)
xcodebuild archive \
    -scheme Localazy-macOS \
    -sdk macosx MACOSX_DEPLOYMENT_TARGET=10.15 \
    -arch x86_64 \
    -arch arm64 \
    -archivePath "$ARCHIVES_DIR/macos.xcarchive" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO

# Build XCFramework
xcodebuild -create-xcframework \
    -framework $ARCHIVES_DIR/ios_devices.xcarchive/Products/Library/Frameworks/Localazy_iOS.framework \
    -framework $ARCHIVES_DIR/ios_simulators.xcarchive/Products/Library/Frameworks/Localazy_iOS.framework \
    -framework $ARCHIVES_DIR/macos.xcarchive/Products/Library/Frameworks/Localazy_macOS.framework \
    -output $BUILD_DIR/Localazy.xcframework