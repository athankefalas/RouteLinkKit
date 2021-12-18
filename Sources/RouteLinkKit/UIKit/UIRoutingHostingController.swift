//
//  UIRoutingHostingController.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation
import SwiftUI

/// A UIKit view controller that supports routing and presents a specified SwiftUI.View as it's content.
open class UIRoutingHostingController<RootView: View, Route: Hashable>: UIHostingController<RootView>, AnyRoutingViewController {
    
    /// The route this view controller is presenting
    public var route: Route!
    
    /// Creates a new instance of a UIRoutingHostingController that will will present the given view for the given route.
    /// - Parameters:
    ///   - route: The route this view controller is presenting
    ///   - contentView: The view that will be presented as this view controllers content
    public init(presenting route: Route, content contentView: RootView) {
        self.route = route
        super.init(rootView: contentView)
        additionalSafeAreaInsets = .zero
    }
    
    @MainActor @objc required dynamic public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func isPresenting<SomeRoute>(route: SomeRoute) -> Bool where SomeRoute : RouteRepresenting {
        guard route is Route,
              let presentedRoute = self.route else {
                  return false
              }
        
        return presentedRoute.hashValue == route.hashValue
    }
}
