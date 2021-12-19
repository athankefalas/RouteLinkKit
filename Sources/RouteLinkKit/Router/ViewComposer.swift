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
//  ViewComposer.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation
import SwiftUI

/// A type that can compose instances of SwiftUI.View dynamically for a given route.
public protocol ViewComposer: AnyObject {
    
    /// Creates a type erased SwiftUI.View for the given route.
    /// - Parameter route: The route for which a new view needs to be composed.
    /// - Returns: A type erased view that visually represents the given route.
    func composeView<Route: RouteRepresenting>(for route: Route) -> AnyView
}
