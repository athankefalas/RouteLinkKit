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
//  RouteLink.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation
import SwiftUI

/// A view that controls a routed navigation presentation, managed by the router available in the current `RoutedNavigationView` context.
public struct RouteLink<Route: RouteRepresenting, Label: View>: View {

    @Environment(\.routing) var routing

    private let label: () -> Label
    private let navigationLink: (AnyRouter) -> NavigationLink<Label, AnyView>

    /// Creates a routed navigation link that presents a composed destination view.
    /// - Parameters:
    ///   - route: A route that can be used to compose a SwiftUI.View `destination`.
    ///   - label: A view builder to produce a label describing the `destination`
    ///    to present.
    public init(to route: Route, @ViewBuilder label: @escaping () -> Label) {
        self.label = label
        self.navigationLink = { router in
            NavigationLink(destination: {
                let routeContent = router.routeViewComposer.composeView(for: route)
                routeContent.contentView()
            }, label: label)
        }
    }

    /// Creates a routed navigation link that presents a composed destination view when active.
    /// - Parameters:
    ///   - isActive: A binding to a Boolean value that indicates whether `destination` is currently presented.
    ///   - route: A route that can be used to compose a SwiftUI.View `destination`.
    ///   - label: A view builder to produce a label describing the `destination`
    ///    to present.
    public init(isActive: Binding<Bool>, to route: Route, @ViewBuilder label: @escaping () -> Label) {
        self.label = label
        self.navigationLink = { router in
            NavigationLink(isActive: isActive, destination: {
                let routeContent = router.routeViewComposer.composeView(for: route)
                routeContent.contentView()
            }, label: label)
        }
    }

    /// Creates a routed navigation link that presents a composed destination view when
    /// a bound selection variable equals a given tag value.
    /// - Parameters:
    ///   - tag: The value of `selection` that causes the link to present `destination`.
    ///   - selection: A bound variable that causes the link to present `destination` when `selection` becomes equal to `tag`.
    ///   - route: A route that can be used to compose a SwiftUI.View `destination`.
    ///   - label: A view builder to produce a label describing the `destination` to present.
    public init<SomeTag: Hashable>(tag: SomeTag, selection: Binding<SomeTag?>, to route: Route, @ViewBuilder label: @escaping () -> Label) {
        self.label = label
        self.navigationLink = { router in
            NavigationLink(tag: tag, selection: selection, destination: {
                let routeContent = router.routeViewComposer.composeView(for: route)
                routeContent.contentView()
            }, label: label)
        }
    }

    public var body: some View {
        if let router = routing.router { // If a router exists in the environment,
            navigationLink(router)
        } else { // no router was found, return a disabled navigation link
            fallbackView()
        }
    }

    private func fallbackView() -> some View {
        assertionFailure("RouteLinkKit: Unable to find a router in the app environment.")

        return NavigationLink {
            EmptyView()
        } label: {
            label().disabled(true)
        }
    }
}
