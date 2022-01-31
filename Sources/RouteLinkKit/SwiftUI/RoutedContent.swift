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
//  RoutedContent.swift
//  
//
//  Created by Athanasios Kefalas on 21/12/21.
//

import Foundation
import SwiftUI

/// A container of a SwiftUI view used for route view composition.
/// This container can be used when returning `some View` from a `@ViewBuilder` is not possible.
public struct RoutedContent {
    
    let contentView: () -> AnyView
    
    /// Creates a new instance with an empty content view
    public init() {
        self.contentView = {
            AnyView(erasing: EmptyView())
        }
    }
    
    /// Creates a new instance with the specified content view
    /// - Parameter contentView: A function that returns the content view of this RoutedContent instance
    public init<SomeView: View>(@ViewBuilder _ contentView: @escaping () -> SomeView) {
        self.contentView = {
            AnyView(erasing: contentView())
        }
    }
    /// Creates a new instance with the specified content view by accepting a generic `Route` and converting it to a concrete `Route` type.
    /// - Parameters:
    ///    - route: A generic route instance
    ///    - routeType: The type to attemp to convert route into
    ///    - contentView: A function that accepts the converted `Route` and returns the content view of this RoutedContent instance
    public init<AnyRoute: RouteRepresenting, Route: RouteRepresenting, SomeView: View>(of route: AnyRoute, as routeType: Route.Type = Route.self, @ViewBuilder _ contentView: @escaping (Route) -> SomeView) {
        guard let route = route as? Route else {
            assertionFailure("RouteLinkKit: Failed to convert route '\(route)' from type '\(type(of: route))' to type '\(routeType)'.")
            self.contentView = {
                AnyView(erasing: EmptyView())
            }
            
            return
        }
        
        self.contentView = {
            AnyView(erasing: contentView(route))
        }
    }
}
