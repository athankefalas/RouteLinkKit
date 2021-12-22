//
// Copyright 2021 Athanasios Kefalas
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  UIRoutingHostingController.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation
import SwiftUI

/// A UIKit view controller that supports routing and presents a specified SwiftUI.View as it's content.
open class UIRoutingHostingController<RootView: View, Route: Hashable>: UIHostingController<RootView>, AnyRoutingController {
    
    /// The route this view controller is presenting
    public var route: Route!
    
    /// Creates a new instance of a UIRoutingHostingController that will will present the given view for the given route.
    /// - Parameters:
    ///   - route: The route this view controller is presenting
    ///   - contentView: The view that will be presented as this view controllers content
    public init(presenting route: Route, content contentView: RootView) {
        self.route = route
        super.init(rootView: contentView)
    }
    
    @MainActor @objc required dynamic public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func isPresenting<SomeRoute>(route: SomeRoute) -> Bool where SomeRoute : RouteRepresenting {
        guard let presentedRoute = self.route,
              route is Route else {
                  return false
              }
        
        return presentedRoute.hashValue == route.hashValue
    }
}
