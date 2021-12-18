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

    @Environment(\.router) var routing

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
                router.routeViewComposer.composeView(for: route)
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
                router.routeViewComposer.composeView(for: route)
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
                router.routeViewComposer.composeView(for: route)
            }, label: label)
        }
    }

    public var body: some View {
        if let router = routing.router {
            navigationLink(router)
        } else {
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
