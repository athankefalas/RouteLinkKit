//
//  RoutedNavigationView.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation
import SwiftUI

/// A view for presenting a routed stack of views that represents a visible trail in a navigation hierarchy.
/// The underlying navigation is controlled by a UIKit navigation controller and managed by a router.
public struct RoutedNavigationView<Router: RouteLinkKit.Router>: View {
    
    private struct UIKitRoutedContent: UIViewControllerRepresentable {
        private let navigationController: UINavigationController
        
        init(router: Router) {
            self.navigationController = router.navigationController
            
            guard router.navigationController.viewControllers.isEmpty else {
                // The navigation controller was already set up, meaning this
                // is just a state refresh so return
                return
            }
            
            let rootRoute = router.rootRoute
            let rootRouteView = router.routeViewComposer.composeView(for: rootRoute)
            let rootViewController = UIRoutingHostingController(presenting: rootRoute, content: rootRouteView)
            
            self.navigationController.viewControllers = [rootViewController]
        }
        
        func makeUIViewController(context: Context) -> UINavigationController {
            return navigationController
        }
        
        func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    }
    
    @Binding private var router: Router
    
    /// Creates a new routed navigation view
    /// - Parameter router: The router that will be used to manage this navigation hierarchy.
    public init(using router: Binding<Router>) {
        self._router = router
    }
    
    public var body: some View {
        if #available(iOS 14.0, *) {
            UIKitRoutedContent(router: router)
                .ignoresSafeArea()
                .routing(with: router)
        } else {
            // Fallback on earlier versions
            UIKitRoutedContent(router: router)
                .edgesIgnoringSafeArea(.all)
                .routing(with: router)
        }
    }
}
