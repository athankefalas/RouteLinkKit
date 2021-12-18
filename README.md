# RouteLinkKit

A lightweight iOS mini framework that enables programmatic navigation with SwiftUI. 
RouteLinkKit is fully compatible with native NavigationLinks, while also supporting features available when using UINavigationController.

## 🛠 Features

RouteLinkKit has the following features:
* Supports vanilla SwiftUI lifecycle apps.
* Supports native NavigationLinks and state driven navigation.
* Supports automatic master-detail and sidebar setup done by SwiftUI.
* Supports mixing declarative and programmatic (imperative) navigation schemes.
* Uses UIKit based navigation, and exposes the navigation controller in use.

**Limitations:**
* Uses UIKit based navigation, which limits any product to work only on platforms that support UIKit.
* Minor set up and configuration may be required.

### ❗️Disclaimer

This mini framework is simply a proof of concept, and has only been tested with iOS and iPadOS, using the SwiftUI App lifecycle.
If you plan to use this framework, please do an extensive round of testing before commiting to it.
As a result, it is provided as is and without ANY warranty of any kind.

[TOC]

## 📦 Instalation

### Swift Package

You may add RouteLinkKit as a Swift Package dependency using Xcode 11.0 or later, by selecting `File > Swift Packages > Add Package Dependency...` or `File > Add packages...` in Xcode 13.0 and later, and adding the url below:

`https://github.com/athankefalas/RouteLinkKit.git`

### Manually 

You may also install this framework manually by downloading the `RouteLinkKit` project and including it in your project.

## ⚡️ Quick setup

This section will contain an example setup, for a app that displays a list of products.

1. Define a set of Routes

```swift
enum ProductRoutes: RouteRepresenting {
    case productsList
    case selectedProduct(productId: Int)
    case viewingProductDescription(productId: Int)
}
```

Each route must be uniquely identifiable by a view composer by using it's hash value within a specific navigation stack.

2. Define a ViewComposer

```swift
class ProductsViewComposer: ViewComposer {
    
    func composeView<Route>(for route: Route) -> AnyView where Route : RouteRepresenting {
        guard let productsRoute = route as? ProductRoutes else {
            assertionFailure("ProductsViewComposer: Failed to compose a view for route '\(route)' of type '\(type(of: route))'.")
            return AnyView( EmptyView() )
        }
        
        switch route {
        case .productsList:
            return AnyView( ProductsView() )
        case .selectedProduct(productId: let productId):
            return AnyView( ProductDetailsView(productId: productId) )
        case .viewingProductDescription(productId: let productId):
            return AnyView( ProductDescriptionView(productId: productId) )
        }
    }
}
```

The view composer must know how to compose and create new views for each of the routes it supports.

3. Create a router

``` swift
class ProductsRouter: Router {
    let navigationController = UIRoutingNavigationController()
    let routeViewComposer: ViewComposer = ProductsViewComposer()
    
    let rootRoute = ProductRoutes.productsList
}
```

The router is injected in the environment values of all views that are descendants of a RoutedNavigationView and can be used in the following way:

```swift

struct SomeView: View {

    @Environment(\.routing) var routing: RoutingEnvironment

    var body: some View { ..... }

    func popToRoot() {
        // Use common methods
        routing.router?.dismissToRoot(animated: true)
    }
    
    func showTrail() {
        guard let router = routing.router as? ProductsRouter else {
            return
        }
        
        // Use common Route-dependant methods
        routing.router?.dismiss(to: MyRoutes.root)
        routing.router?.show(route: MyRoutes.details, animated: false)
        routing.router?.show(trail: [MyRoutes.root, .details, .edit])
    }

    func showTrailCustom() {
        // Dig down to UIKit to provide more custom functionality
        routing.router?.navigationController.setViewControllers([...], animated: true)
    }
}

```

4. Replace NavigationView with RoutedNavigationView 

```swift
struct TestProductsApp: App {
    
    @StateObject private var router = ProductsRouter()
    
    var body: some Scene {
        WindowGroup {
            // Replace:
            NavigationView {
              ProductsView()
            }
            // With:
            RoutedNavigationView(using: $router)
        }
    }
 }
 ```
 
 5. Replace NavigationLink with RouteLink (Optional)

```swift
struct ProductsView: View {
    @State private var products: [Product] = Product.previewProducts
    @State private var selection: Product?
    
    var body: some View {
        List {
            ForEach(products, id: \.self) { product in
                // If no dynamic view resolution is required, use NavigationLink.
                // It will work normally when placed within RoutedNavigationViews.
                NavigationLink(tag: product, selection: $selection) {
                    ProductDetailsView(productId: product.id)
                } label: {
                    Text(product.title)
                }
                
                // If dynamic view resolution is required, then use RouteLink
                // The view can the be dynamically resolved at runtime by using
                // the provided View Composer.
                RouteLink(tag: product, selection: $selection, to: ProductRoutes.selectedProduct(productId: product.id)) {
                    Text(product.title)
                }
            }
        }
    }
}
```

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

