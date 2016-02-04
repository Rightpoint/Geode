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
