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
//  AnyViewControllerBuilder.swift
//  
//
//  Created by Athanasios Kefalas on 21/12/21.
//

import Foundation

/// A type that can create Routing UIViewControllers for a specific route of a specific router.
/// The default instance of AnyViewControllerBuilder used internally by RouteLinkKit can be accessed,
/// or set from the `ViewControllerBuilder.defaultBuilder` static property.
public protocol AnyViewControllerBuilder {
    
    /// Creates a new routing UIViewController for the specified route of the specified router.
    /// - Parameters:
    ///   - route: The route for which to build a routing UIViewController for.
    ///   - router: The router that manages the given route.
    /// - Returns: A new routing UIViewController.
    func buildViewController<SomeRouter: Router>(for route: SomeRouter.Route, of router: SomeRouter) -> AnyRoutingUIViewController
}

public extension AnyViewControllerBuilder {
    
    /// Creates a new routing UIViewController for the root route of the specified router.
    /// - Parameters:
    ///   - router: The router whose root route will be used a routing UIViewController for.
    /// - Returns: A new routing UIViewController.
    func buildViewController<SomeRouter: Router>(forRootRouteOf router: SomeRouter) -> AnyRoutingUIViewController {
        return buildViewController(for: router.rootRoute, of: router)
    }
}
