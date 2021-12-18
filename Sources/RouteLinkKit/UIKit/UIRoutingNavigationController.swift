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
//  UIRoutingNavigationController.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation
import UIKit

/// A subclass of UINavigationController used specifically to display routed SwiftUI views.
open class UIRoutingNavigationController: UINavigationController, AnyRoutingViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Config to match SwiftUI NavigationView behaviour
        navigationBar.prefersLargeTitles = true
    }
    
    /// Replaces the view controllers currently managed by the navigation controller with the specified items.
    /// - Parameters:
    ///   - viewControllers: The view controllers to place in the stack. The front-to-back order of the controllers
    ///                      in this array represents the new bottom-to-top order of the controllers in the navigation stack. Thus, the last
    ///                      item added to the array becomes the top item of the navigation stack.
    ///   - animated: If true, animate the pushing or popping of the top view controller. If false, replace the view controllers without any animations.
    ///
    ///Use this method to update or replace the current view controller stack without pushing or popping each controller explicitly. In addition, this method lets you update the set of controllers without animating the changes, which might be appropriate at launch time when you want to return the navigation controller to a previous state.
    /// If animations are enabled, this method decides which type of transition to perform based on whether the last item in the items array is already in the navigation stack. If the view controller is currently in the stack, but is not the topmost item, this method uses a pop transition; if it is the topmost item, no transition is performed. If the view controller is not on the stack, this method uses a push transition. Only one transition is performed, but when that transition finishes, the entire contents of the stack are replaced with the new view controllers. For example, if controllers A, B, and C are on the stack and you set controllers D, A, and B, this method uses a pop transition and the resulting stack contains the controllers D, A, and B.
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        // If there are any view controllers presented, then
        if !self.viewControllers.isEmpty {
            // Silently dismiss all previously displayed view controllers to deactivate active nav links
            popToRootViewController(animated: false)
        }
       
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    public func isPresenting<SomeRoute>(route: SomeRoute) -> Bool where SomeRoute : RouteRepresenting {
        // The route this view controller is presenting is equal to the one
        // presented by the top view controller
        guard let topViewController = viewControllers.last as? AnyRoutingViewController else {
            return false
        }
        
        return topViewController.isPresenting(route: route)
    }
}
