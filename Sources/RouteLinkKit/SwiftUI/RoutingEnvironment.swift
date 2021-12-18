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
//  RoutingEnvironment.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation
import SwiftUI

/// An environment stored value that holds a reference to the router managing the current navigation context.
public struct RoutingEnvironment {
    
    /// The active router in the current navigation context, or nil if no router is active.
    public var router: AnyRouter?
}

/// A key for accessing the routing environment values in the current environment context.
public struct RoutingEnvironmentKey: EnvironmentKey {
    
    public static var defaultValue = RoutingEnvironment(router: nil)
}

public extension EnvironmentValues {
    
    /// The key for accessing the routing environment value.
    var routing: RoutingEnvironment {
        get { self[RoutingEnvironmentKey.self] }
        set { self[RoutingEnvironmentKey.self] = newValue }
    }
}

public extension View {
    
    /// Sets the active router in the current navigation context.
    /// - Parameter router: The currently active router.
    /// - Returns: A view that has the given value set in its environment.
    func routing(with router: AnyRouter?) -> some View {
        environment(\.routing, .init(router: router))
    }
}
