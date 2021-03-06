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
//  Router.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation
import UIKit

/// A type that represents a functioning router with a root view.
public protocol Router: AnyRouter {
    associatedtype Route: RouteRepresenting
    
    /// The root route this router supports.
    var rootRoute: Route { get }
}

public extension Router {
    
    // MARK: Common Navigation Functions
    
    func restart(animated: Bool = true) {
        let rootViewController = buildViewController(for: rootRoute)
        navigationController.setViewControllers([rootViewController], animated: animated)
    }
    
    func dismiss(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    /// Dismiss the top views in the current navigation stack, until reaching the first instance of the specified route.
    /// - Parameters:
    ///   - route: The route which will be displayed as the new top of the current navigation stack
    ///   - animated: Transtion animation flag
    func dismiss(to route: Route, animated: Bool = true) {
        let viewControllers = navigationController.viewControllers
        let viewControllersReversedIndices = viewControllers.indices.reversed()
        
        for index in viewControllersReversedIndices {
            let viewController = viewControllers[index]
            
            if let routableViewController = viewController as? AnyRoutingController,
               routableViewController.isPresenting(route: route) {
                navigationController.popToViewController(viewController, animated: animated)
                return
            }
        }
    }
    
    /// Dismiss the top views in the current navigation stack, until reaching the view before the specified route.
    /// - Parameters:
    ///   - route: The route which will be displayed as the new top of the current navigation stack
    ///   - animated: Transtion animation flag
    func dismiss(before route: Route, animated: Bool = true) {
        let viewControllers = navigationController.viewControllers
        let viewControllersReversedIndices = viewControllers.indices.reversed()
        
        for index in viewControllersReversedIndices {
            let viewController = viewControllers[index]
            
            if let routableViewController = viewController as? AnyRoutingController,
               routableViewController.isPresenting(route: route) {
                
                let previousViewControllerIndex = viewControllers.index(before: index)
                
                guard viewControllersReversedIndices.contains(previousViewControllerIndex) else {
                    navigationController.popToViewController(viewController, animated: animated)
                    return
                }
                
                navigationController.popToViewController(viewControllers[previousViewControllerIndex], animated: animated)
                return
            }
        }
    }
    
    func dismissToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    /// Shows a new view for the specified route at the top of the current navigation stack.
    /// - Parameters:
    ///   - route: The route for which to create and show a view for.
    ///   - animated: Transtion animation flag.
    func show(route: Route, animated: Bool = true) {
        let viewController = buildViewController(for: route)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /// Presents a new view modally for the specified route at the top of the current navigation stack.
    /// - Parameters:
    ///   - route: The route for which to create and show a view for.
    ///   - animated: Transtion animation flag.
    func present(route: Route, animated: Bool = true) {
        let viewController = buildViewController(for: route)
        navigationController.present(viewController, animated: true)
    }
    
    /// Shows a new trail of routes, replacing the current navigation stack.
    /// The new trail will attempt to reuse any views that are already presented
    /// in the current trail. This method can also be used to respond to observed
    /// changes of a `trail` published value to statefully manage the current navigation trail.
    /// - Parameters:
    ///   - route: The route for which to create and show a view for.
    ///   - animated: Transtion animation flag.
    func show(trail path: [Route], animated: Bool = true) {
        let existingViewControllers = navigationController.viewControllers
        var viewControllers: [UIViewController] = []
        
        var createNewViewControllers = false
        
        for (index, route) in path.enumerated() {
            let isIndexValidInExistingViewControllers = existingViewControllers.indices.contains(index)
            
            guard !createNewViewControllers,
                  isIndexValidInExistingViewControllers,
                  isRoute(route, presentedBy: existingViewControllers[index]) else {
                      
                      let viewController = buildViewController(for: route)
                      viewControllers.append(viewController)
                      
                      createNewViewControllers = true
                      
                      continue
                  }
            
            viewControllers.append(existingViewControllers[index])
        }
        
        // If nothing changed in the navigation stack, return
        guard viewControllers.hashValue != navigationController.hashValue else {
            return
        }
        
        navigationController.setViewControllers(viewControllers, animated: animated)
    }
    
    // MARK: Helpers
    
    private func isRoute(_ route: Route, presentedBy viewController: UIViewController) -> Bool {
        guard let routingViewController = viewController as? AnyRoutingController else {
            return false
        }
        
        return routingViewController.isPresenting(route: route)
    }
    
    private func buildViewController(for route: Route) -> UIViewController {
        return ViewControllerBuilder.defaultBuilder.buildViewController(for: route, of: self)
    }
}
