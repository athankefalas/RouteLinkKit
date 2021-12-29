//
//  UIRoutingViewController.swift
//  
//
//  Created by Αθανάσιος Κεφαλάς on 29/12/21.
//

import Foundation
import UIKit

/// A UIViewController base class that can be used to present a specific route. This type can be used to directly show a `UIKit` UIVIewController when using
/// routed navigation views without bridging to `SwiftUI` and back to `UIKit`.
open class UIRoutingViewController<Route: RouteRepresenting>: UIViewController, AnyRoutingController {
    
    /// The route this view controller is presenting
    var route: Route!
    
    /// Creates a new instance of a UIViewController for the given route
    /// - Parameters:
    ///   - route: The route this view controller will present
    ///   - nibName: The name of the nib file to associate with the view controller. The nib file name should not contain any leading path information. If you specify nil, the nibName property is set to nil.
    ///   - bundle: The bundle in which to search for the nib file. This method looks for the nib file in the bundle's language-specific project directories first, followed by the Resources directory.
    public init(route: Route, nibName: String?, bundle: Bundle?) {
        self.route = route
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func isPresenting<SomeRoute>(route: SomeRoute) -> Bool where SomeRoute : RouteRepresenting {
        guard let presentedRoute = self.route,
              route is Route else {
                  return false
              }
        
        return presentedRoute.hashValue == route.hashValue
    }
}
