# Localazy iOS and macOS SDK

To see Localazy SDK in action, you can check our demo project [here](https://github.com/localazy/ios-demo).

## Installation and Setup

### 📦  Swift Package Manager

Localazy SDK for iOS and macOS is distributed with [Swift Package Manager](https://swift.org/package-manager/) as a binary package.

Add this URL to Swift Packages in your Project file (Xcode 12 and upwards).
```
https://github.com/localazy/localazy-swift
```

Minimum target:
- iOS 13
- macOS 10.15

### 👷 Manual installation

To install Localazy SDK manually, copy `Localazy.xcframework` into your project root (Xcode) and add it to the **Frameworks, Libraries and Embedded Content** section.

### ⚙️ Setup
In your code you can import Localazy by adding:
```swift
#if os(macOS)
import Localazy_macOS
#else
import Localazy_iOS
#endif
```

### 💻 macOS
For macOS targets you need to ensure `Outgoing connections (Client)`  and `Disable Library Validation` entitlement is checked in `Signing & Capabilities (App Sandbox)` section.

### 🎛 Configuration
To configure Localazy SDK for iOS and macOS create and set up `Localazy.plist` configuration file. You can copy `Localazy.plist` from this package to your Xcode project.
#### `Localazy.plist`
| Key | Type | Description | Default |
|---|---|---|---|
| `readKey` | `String` | Your Localazy read key. (Can be retrieved from settings.) | `null` |
| `tag` | `String` | Release tag to be used to fetch translations. | `latest` |
| `statistics` | `Dictionary` | Statistics configuration dictionary allows Localazy to optimize its behaviour and prioritize translations. (see table below) | `-` |

#### `statistics`
| Key | Type | Description | Default |
|---|---|---|---|
| `statsEnabled` | `Boolean` | Should the library send stats | `true` |
| `updateInterval` | `Number` | Update interval in ms | `86400` |
| `updateIntervalForFailure` | `Number` | Update interval for failure in ms | `14400` |
| `statsInterval` | `Number` | Send stats interval in ms | `86400` |
| `statsIntervalForFailure` | `Number` | Send stats interval for failure in ms | `14400` |
| `updateDelay` | `Number` | Update delay in ms | `0` |
| `statsDelay` | `Number` | Stats delay in ms | `0` |
| `minimalStatsSize` | `Number` | Minimal stats size in bytes | `2048` |
| `maximumStatsSize` | `Number` | Maximum stats size in bytes | `262144` |
| `sendStatsRegularly` | `Boolean` | Send stats regularly | `false` |



#### Example configuration file (Localazy.plist)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>readKey</key>
  <string>Your-Read-Key</string>
  <key>tag</key>
  <string>Your-Tag</string>
  <key>updateInterval</key>
  <integer>3600</integer>
  <key>statistics</key>
  <dict>
	  <key>statsEnabled</key>
	  <true/>
	  <key>sendStatsRegularly</key>
	  <true/>
	  <key>statsInterval</key>
	  <integer>900</integer>
  </dict>
</dict>
</plist>
```

### 🤖 Automatic strings upload

You can ensure your local strings are uploaded on every build by creating new **Run Script Phase** for your target:
```bash
localazy upload
```
For more info check  [Installation – Localazy CLI](https://localazy.com/docs/cli/installation) & [Upload Reference - Localazy CLI.](https://localazy.com/docs/cli/upload-reference)

## Usage

### 💡 Shared instance
To start using Localazy SDK, access singleton instance by:
```swift
Localazy.shared
```

### ⌨️  Basic usage

#### Use **String extension** to get localized String:
```swift
"Hello".localazyLocalized
```

#### Use **Text (SwiftUI) constructor** to get localized String:
```swift
Text(localazyKey: "Hello")
```

#### Enable **method swizzling (Beta)** to enable Localazy functionality on system methods:
```swift
Bundle.swizzleLocalizationWithLocalazy()
NSLocalizedString("Hello", comment: "Hello")
```

> **NOTE**: By using swizzling its important to understand it will replace all calls to `NSLocalizedString` with the custom logic provided by Localazy SDK and will only fallback to system call if there is no Localazy based translation. For this reasons, there may be more logs added to statistics about the missing and used keys.

### 🔌 Public API

- `forceReload`: Invalidate internal caches and reload data from server
- `forceLocale`: Set locale independently from system settings (allows for custom language selectors)
- `getString`: Get translated String
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

### 🔔 Notifications
We provide several types of notifications which can be produced by the SDK. These notifications are published as a `NSNotification` objects and can be observed by [NotificationCenter](https://developer.apple.com/documentation/foundation/notificationcenter/). Some of these notifications can contain `userInfo` dictionary to provide more context for you.

#### The key is not translated into the current language:
- `localazyMissingTextFound`
- `userInfo` dictionary: 
```
[
	"id": LocalazyID, 
	"locale": LocalazyLocale, 
	"key": String
]
```

#### The library has started the update process:
- `localazyStringsUpdateStarted`

#### The library has updated the translation data:
- `localazyStringsUpdateFinished`

#### The data update process failed with an error:
- `localazyStringsUpdateFailed`
- `userInfo` dictionary: 
```
[
	“error”: Localazy.LocalazyError
]
```

#### The library contacted the update server and found out that there is no change:
- `localazyStringsUpdateNotNecessary`

#### The library has loaded data – this is called after initial load, strings update, etc:
- `localazyStringsLoaded`
