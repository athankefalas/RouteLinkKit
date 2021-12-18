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
    var router: RoutingEnvironment {
        get { self[RoutingEnvironmentKey.self] }
        set { self[RoutingEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Sets the active router in the current navigation context.
    /// - Parameter router: The currently active router.
    /// - Returns: A view that has the given value set in its environment.
    func routing(with router: AnyRouter?) -> some View {
        environment(\.router, .init(router: router))
    }
}
