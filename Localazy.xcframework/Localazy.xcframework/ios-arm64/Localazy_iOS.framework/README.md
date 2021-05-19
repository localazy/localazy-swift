# Localazy iOS and macOS SDK

## Installation and Setup

### Installation

#### Swift Package Manager

Localazy SDK for iOS and macOS is distributed with [Swift Package Manager](https://swift.org/package-manager/) as a binary package.

Minimum target:
- iOS 13
- macOS 10.15

Add this URL:
```
https://github.com/localazy/localazy-swift
```
to Swift Packages in your Project file (Xcode 12 and upwards).

#### Manual installation

Copy Localazy.xcframework into your project root (Xcode) and add it to the “Frameworks, Libraries and Embedded Content” section.

### Setup

In your code you can import Localazy by adding:
```
#if os(macOS)
import Localazy_macOS
#else
import Localazy_iOS
#endif
```

#### MacOS

For MacOS targets you need to ensure `Outgoing connections (Client)` entitlement is checked in `Signing & Capabilities (App Sandbox)` section.

### Configuration

To configure Localazy SDK for iOS and macOS create and set up `Localazy.plist` configuration file. You can copy Localazy.plist from this package to your Xcode project.

- `readKey: String` - Your Read Key.
- `tag: String` - Tag to be used to fetch you translations. If not specified `latest` is used.
- `statistics: Dictionary` - Statistics configuration array.
	- `statsEnabled: Boolean`
	- `updateInterval: Number`
	- `updateIntervalForFailure: Number`
	- `statsInterval: Number`
	- `statsIntervalForFailure: Number`
	- `updateDelay: Number`
	- `statsDelay: Number`
	- `minimalStatsSize: Number`
	- `maximalStatsSize: Number`
	- `updateForActivityOnly: Boolean`
	- `sendStatsRegularly: Boolean`

#### Example configuration file (Localazy.plist)

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>readKey</key>
	<string></string>
	<key>tag</key>
	<string></string>
	<key>statistics</key>
	<dict>
		<key>statsEnabled</key>
		<true/>
		<key>updateInterval</key>
		<integer>0</integer>
	</dict>
</dict>
</plist>

```

### Automatic strings upload

You can ensure your strings are uploaded on every build by creating new Run Script Phase for your target:
```
localazy upload
```
[For more info check Uload Reference for Localazy CLI.](https://localazy.com/docs/cli/upload-reference)

## Usage

### Shared instance
To start using Localazy SDK, access singleton instance with:
```
Localazy.shared
```

### Basic usage

Use String extension to get localized String:
```
"Hello".localazyLocalized
```

Use Text (SwiftUI) constructor to get localized String:
```
Text(localazyKey: "Hello")
```

Enable method swizzling (Beta) to enable Localazy functionality on system methods:
```
Bundle.swizzleLocalizationWithLocalazy()
NSLocalizedString("Hello", comment: "Hello")
```

### Public API

- `forceReload`: Invalidate internal caches and reload data
- `getString`: Translated String
- `getArrayList`: Translated List
- `getPlural`: Translated String with plurals
- `setEnabled`: If Localazy is disabled, translations are obtained by the default system mechanism.
- `getProjectUrl`: Project URL
- `getCurrentLocale`: Current system locale
- `getCurrentLocalazyLocale`: Current Localazy locale
- `isFullyTranslated`: To get information about whether the current internally resolved locale is fully translated
- `getLocales`: To list all locales known to Localazy
- `isStatsEnabled`: Statistics are enabled
- `setStatsEnabled`: Enable / disable statistics

## Notifications

We provide several types of notifications which can be produced by the SDK. These notifications are published as a NSNotification objects and can be observed by [NotificationCenter](https://developer.apple.com/documentation/foundation/notificationcenter/). Some of these notifications can contain `userInfo` dictionary to provide more context for you.

#### The key is not translated into the current language:
- localazyMissingTextFound
- `userInfo` dictionary: 
```
[
	“id”: LocalazyID, 
	“locale”: LocalazyLocale, 
	“key”: String
]
```

#### The library has started the update process:
- localazyStringsUpdateStarted

#### The library has updated the translation data:
- localazyStringsUpdateFinished

#### The data update process failed with an error:
- localazyStringsUpdateFailed
- `userInfo` dictionary: 
```
[
	“error”: Localazy.LocalazyError
]
```

#### The library contacted the update server and found out that there is no change:
- localazyStringsUpdateNotNecessary

#### The library has loaded data - this is called after initial load, strings update, etc:
- localazyStringsLoaded

