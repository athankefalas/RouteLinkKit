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
    /// - Returns: A type erased view that visually represents the given route
    func composeView<Route: RouteRepresenting>(for route: Route) -> AnyView
}
