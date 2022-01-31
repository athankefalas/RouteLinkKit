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
//  UIRoutingSplitViewController.swift
//
//
//  Created by Athanasios Kefalas on 30/12/21.
//

import Foundation
import UIKit

/// A UISplitViewController subclass that can be used to manage routing view controllers. This view controller can be used
/// to bridge to UIKit in order to use Master/Detail or Sidebar navigation idioms with routing view controllers.
open class UIRoutingSplitViewController: UISplitViewController, AnyRoutingController {
    
    open func isPresenting<SomeRoute>(route: SomeRoute) -> Bool where SomeRoute : RouteRepresenting {
        for viewController in viewControllers {
            guard let viewController = viewController as? AnyRoutingController else {
                continue
            }
            
            if viewController.isPresenting(route: route) {
                return true
            }
        }
        
        return false
    }
}
