# Geode
[![Build Status](https://travis-ci.org/Raizlabs/Geode.svg)](https://travis-ci.org/Raizlabs/Geode)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Geode.svg)](https://github.com/CocoaPods/CocoaPods)

Location management made easy.

## Installation with Carthage

Carthage is a decentralized dependency manager that automates the process of
adding frameworks to your Cocoa application.

You can install Carthage with Homebrew using the following commands:

```sh
brew update
brew install carthage
```

To integrate Geode into your Xcode project using Carthage, specify it in
your Cartfile:

```ruby
github "Raizlabs/Geode"
```

Run `carthage update` to build the framework and drag the built
`Geode.framework` into your Xcode project.

## Installation with CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects.
You can install it with the following command:

```sh
$ gem install cocoapods
```

To integrate Geode into your Xcode project using CocoaPods, specify it in
your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

pod 'Geode'
```

Then, run the following command:

```sh
$ pod install
```

## Usage

### One-shot Location Access

iOS 9 introduced the ability to request the one-time delivery of the user's
current location. This approach does not keep location services running
longer than what is necessary to obtain a location fix. One common use case
is to tie a location update to an action so that the user can refresh their
location as needed:

```swift
import Geode

let locator = Geode.GeoLocator(.OneShot)

@IBAction func updateLocationAction() {
    locator.requestLocationUpdate { location in
        debugPrint("Current location: \(location)")
    }
}

```

### Continuous Location Access

Continuous location access (the only method available prior to iOS 9)
supplies location updates to your application as the user's position changes.
This approach will provide you with the most current location data at the
expense of increased battery usage.

You might, for example, tie location monitoring to a view controller's
lifecycle:

```swift
import Geode

let locator = Geode.GeoLocator(.Continuous)

override func viewDidLoad() {
    super.viewDidLoad()

    locator.startMonitoring { location in
        debugPrint("Current location: \(location)")
    }
}

override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated: animated)

    locator.stopMonitoring()
}

```

### Logging

One of the most effective ways to debug location services is to log from your
`CLLocationManagerDelegate`. Geode's implementation is instrumented with
numerous log statements, all of which delegate to a `logHandler` callback that
is `nil` by default. This allows for easy integration with existing logging
frameworks (e.g. [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)).

```swift
public typealias LogHandler = (message: () -> String, level: LogLevel, file: StaticString, line: UInt) -> Void
```

The `message` parameter is passed as a closure, which allows us to potentially
avoid any unnecessary string processing if the log level is not set high enough.
A simple logging implementation might look like the following:

```swift
locator.logHandler = { message, level, file, line in
    debugPrint("[GEODE] \(String(level).uppercaseString) \(file) L\(line): \(message())")
}
```

## Maintainers
- [John Watson](https://github.com/jwatson) ([@johnnystyle](https://twitter.com/johnnystyle))

## License

Geode is released under the MIT license. See [LICENSE](LICENSE) for details.
