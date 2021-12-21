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
//  ViewControllerBuilder.swift
//  
//
//  Created by Athanasios Kefalas on 21/12/21.
//

import Foundation

/// The default ViewControllerBuilder used by RouteLinkKit to create presenting UIViewControllers for SwiftUI views.
/// The default instance of AnyViewControllerBuilder used internally by RouteLinkKit can be accessed,
/// or set from the `defaultBuilder` static property.
open class ViewControllerBuilder: AnyViewControllerBuilder {
    
    /// The default instance of AnyViewControllerBuilder used internally by RouteLinkKit to create routing UIViewControllers.
    /// This property can be set with an instance of AnyViewControllerBuilder, to provide custom view controller building behaviour if needed.
    public static var defaultBuilder: AnyViewControllerBuilder = ViewControllerBuilder()
    
    open func buildViewController<SomeRouter: Router>(for route: SomeRouter.Route, of router: SomeRouter) -> AnyRoutingUIViewController {
        let routeContent = router.routeViewComposer.composeView(for: route)
        let routeContentView = routeContent.contentView()
        return UIRoutingHostingController(presenting: route, content: routeContentView)
    }
}
