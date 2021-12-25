# RouteLinkKit

A lightweight iOS mini framework that enables programmatic navigation with SwiftUI. 
RouteLinkKit is fully compatible with native NavigationLinks, while also supporting features available when using UINavigationController.

## ⏱ Version History

| Version | Changes                  |
|---------|--------------------------|
| 0.8     | Pre-release.             |
| 1.0.0   | Initial Release.         |

## 🛠 Features

RouteLinkKit has the following features:
* Supports vanilla SwiftUI lifecycle apps.
* Supports native NavigationLinks and state driven navigation.
* Supports mixing declarative and programmatic (imperative) navigation schemes.
* Uses UIKit based navigation, and exposes the navigation controller in use.

**Limitations:**
* Supports stacked navigation only. Not directly compatible with SwiftUI automatic sidebar and master-detail navigation configuration.
* Uses UIKit based navigation, which limits any products to work only on platforms that support UIKit.
* Minor set up and configuration may be required.
* All routes managed by a specific router must be of the same base type.
* Limited testing capability due to the fact that internally it uses native NavigationLink views.

### ❗️Disclaimer

This mini framework started as a proof of concept, and has only been tested with iOS and iPadOS, using the SwiftUI App lifecycle.
As a result, it is provided as is and without ANY warranty of any kind.
If you plan to use this framework, especially in producion code, please do a round of testing before commiting to it.


## 📦 Instalation

### Swift Package

You may add RouteLinkKit as a Swift Package dependency using Xcode 11.0 or later, by selecting `File > Swift Packages > Add Package Dependency...` or `File > Add packages...` in Xcode 13.0 and later, and adding the url below:

`https://github.com/athankefalas/RouteLinkKit.git`

### Manually 

You may also install this framework manually by downloading the `RouteLinkKit` project and including it in your project.

## ⚡️ Quick Setup

This section will contain an example setup, for a app that displays a list of products and their details.

### 1. Define a set of Routes

A route is a type that can represent the routes available in a specific navigation hierarchy. Each route must be uniquely identifiable by its hash value.
To define a route you can create an `enum`, `struct` or `class` and conform to the `RouteRepresenting` protocol. In the context of the test products app we may define the available routes as the `enum` below:


```swift
enum ProductRoutes: RouteRepresenting {
    case productsList
    case selectedProduct(productId: Int)
    case viewingProductDescription(productId: Int)
}
```


### 2. Define a ViewComposer

A view composer is a type that accepts a route and composes a view to visually represent that specific route. The view composer must know how to compose and create new views for each of the routes it supports. To define a view composer create a `class` and conform to the `ViewComposer` protocol. The only requirement of the protocol, is to define a function that accepts a generic route and returns a view wrapped in a `RoutedContent` type. The `RoutedContent` wrapper accepts a view builder function, that returns the view content for the specified route. If you want to dynamically compose views at runtime, based on the current context of your app, you may do it in the view composer.


```swift
class ProductsViewComposer: ViewComposer {
    
    func composeView<Route>(for route: Route) -> RoutedContent where Route : RouteRepresenting {
        guard let productsRoute = route as? ProductRoutes else {
            assertionFailure("ProductsViewComposer: Failed to compose a view for route '\(route)' of type '\(type(of: route))'.")
            return RoutedContent()
        }
        
        return RoutedContent {
            switch productsRoute {
            case .productsList:
                ProductsView()
            case .selectedProduct(productId: let productId):
                ProductDetailsView(productId: productId)
            case .viewingProductDescription(productId: let productId):
                ProductDescriptionView(productId: productId)
            }
        }
    }
}
```

### 3. Create a router

A router is a type that can be used to manage and perform programmatic navigation. The router holds a reference to the UIKit navigation controller that is currently in use and the view composer for the navigation hierarchy it manages. Finally, a router also contains a property that defines it's root route. The type of the root route, is assumed to be the base type used for all routes in the navigation hierarchy and must conform to the `RouteRepresenting` protocol.


``` swift
class ProductsRouter: Router {
    let navigationController = UIRoutingNavigationController()
    let routeViewComposer: ViewComposer = ProductsViewComposer()
    
    let rootRoute = ProductRoutes.productsList
}
```

#### 3.1 Injecting Routers in Views

The router is also injected in the environment values of all views that are descendants of a `RoutedNavigationView` and can be used in the following way:


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
        routing.router?.dismiss(to: .productsList)
        routing.router?.show(route: .productsList, animated: false)
        routing.router?.show(trail: [.productsList, .selectedProduct(productId:0), .viewingProductDescription(productId:0)])
    }

    func showTrailCustom() {
        // Drop down to UIKit to provide more custom functionality
        routing.router?.navigationController.setViewControllers([...], animated: true)
    }
}

```

#### 3.2 Router API

As previously mentioned, routers came with some common navigation functions built-in, but you can still provide your own by extensions, or by using the navigation controller instance directly if needed. The functions that are already implemented in routers are the following:

|                   Function                   |                       Description                     |
|----------------------------------------------|-------------------------------------------------------|
| dismiss(animated: Bool)                      | Dismiss the top view in the current navigation stack. |
| dismissToRoot(animated: Bool)                | Dismiss all the views in the current navigation stack, until reaching the root view. |
| dismiss(to route: Route, animated: Bool)     | Dismiss the top views in the current navigation stack, until reaching the first instance of the specified route. |
| dismiss(before route: Route, animated: Bool) | Dismiss the top views in the current navigation stack, until reaching the view just before the specified route. |
| restart(animated: Bool)                      | Restart the current navigation stack by destroying all views, and restarts with a new instance of the root view.| 
| show(route: Route, animated: Bool)           | Shows a new view for the specified route at the top of the current navigation stack. |
| present(route: Route, animated: Bool)        | Presents a new view modally for the specified route at the top of the current navigation stack.|
| show(trail path: [Route], animated: Bool)    | Shows a new trail of routes, replacing the current navigation stack. |



### 4. Replace NavigationView with RoutedNavigationView 

One of the two SwiftUI components of RouteLinkKit is `RoutedNavigationView` that simply replaces the native NavigationView,
with a custom implementation that uses a `UINavigationController` subclass for navigation and to provide the navigation bar.
The `RoutedNavigationView` behaves the same as the native `NavigationView` and can even perform native navigation links if needed.
The main difference is that the content of a routed navigation view is automatically created by the router.


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
 
 ### 5. Replace NavigationLink with RouteLink (Optional)

In cases where the destination of navigation links needs to be resolved dynamically at runtime, based on the current context of your app,
use a `RouteLink` instead of a `NavigationLink`. For any dynamic route you require, create the appropriate view in the view composer. The way 
that `RouteLink` is implemented internally uses the native `NavigationLink` with the main difference between the two being that `RouteLink`
doesn't require that the destination to be defined at compile time.


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
                
                // If dynamic view resolution is required, then use RouteLink.
                // The view can then be dynamically resolved at runtime by using
                // the provided View Composer.
                RouteLink(tag: product, selection: $selection, to: ProductRoutes.selectedProduct(productId: product.id)) {
                    Text(product.title)
                }
            }
        }
    }
}
```

## 🧩 Extension Points

The RouteLinkKit mini framework offers a couple possible extension points, that can help to extend and modify the behaviour of the framework.

### UIRoutingNavigationController

An extension point is the navigation controller instance used by the routers. The specific class used in RouteLinkKit is a subclass of `UINavigationController`, 
that is specifically configured to be used with SwiftUI, called `UIRoutingNavigationController`. If you wish to customize the appearance of the navigation bar, 
or perform any other customizations which are only available in UIKit, you can subclass the `UIRoutingNavigationController` and provide your custom 
implementation or even add a navigation controller delegate. The only caveat is that in case of any method overrides you should invoke the superclass implementation if needed.

### ViewControllerBuilder

A second extension point exists and allows for custom behaviour in the creation of the routing UIViewControllers that host the SwiftUI views of routes.
The default view controller creation strategy is implemented in the `ViewControllerBuilder` class, which simple creates a `UIRoutingHostingController`
with the a composed view. The default instance of `ViewControllerBuilder` is created and retained in a static property of the class, called defaultBuilder. 
If you want to manually manage the creation of routing view controllers, you can set this property to a subclass of `ViewControllerBuilder` or a type that 
conforms to the `AnyViewControllerBuilder` protocol.
