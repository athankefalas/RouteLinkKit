# RouteLinkKit

A lightweight iOS mini framework that enables programmatic navigation with SwiftUI. 
RouteLinkKit is fully compatible with native NavigationLinks, while also supporting features available when using UINavigationController.

## 🛠 Features

RouteLinkKit has the following features:
* Supports vanilla SwiftUI lifecycle apps.
* Supports native NavigationLinks and state driven navigation.
* Supports automatic master-detail and sidebar setup done by SwiftUI.
* Mixing declarative and programmatic (imperative) navigation schemes.
* Uses UIKit based navigation, and exposes the navigation controller in use.

**Limitations:**
* Uses UIKit based navigation, which limits any product to work only on platforms that support UIKit.
* Minor set up and configuration may be required.

### ❗️Disclaimer

This mini framework is simply a proof of concept, and has only been tested with iOS and iPadOS, using the SwiftUI App lifecycle.
If you plan to use this framework, please do an extensive round of testing before commiting to it.
As a result, it is provided as is and without ANY warranty of any kind.

[TOC]

## ⬇️ Instalation

### 📦 Swift Package

You may add RouteLinkKit as a Swift Package dependency using Xcode 11.0 or later, by selecting `File > Swift Packages > Add Package Dependency...` or `File > Add packages...` in Xcode 13.0 and later, and adding the url below:

`https://github.com/athankefalas/RouteLinkKit.git`

### 💪 Manually 

You may also install this framework manually by downloading the `RouteLinkKit` project and including it in your project.

## ⚡️ Quick setup

TDB

## 🧩 Framework Overview

The framework has 3 main components that are used to perform programmatic navigation:
* Route - A uniquely identifiable representation of a navigation route. A series of routes in a navigation stack, is referred to as a trail.
* ViewComposer - A type that can compose views for a given route.
* Router - A type that retains a reference to the underlying UINavigationController, the ViewComposer and has a preferred root route. Each navigation stack has a single router.


### Route

TODO

### ViewComposer

TODO

### Router

TODO

### RoutedNavigationView

TODO

### RouteLink

TODO

## Extension Points

TODO

