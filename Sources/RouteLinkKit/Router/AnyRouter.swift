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
//  AnyRouter.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation

/// A type that represents a basic router
public protocol AnyRouter: Routing {
    /// A UIKit based navigation controller used to navigate between views
    var navigationController: UIRoutingNavigationController { get }
    /// A view composer that is used to compose the appropriate SwiftUI.View
    ///  for each for the routes supported by this router.
    var routeViewComposer: ViewComposer { get }
}
