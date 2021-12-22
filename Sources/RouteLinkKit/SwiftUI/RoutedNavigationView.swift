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
        
        private let router: Router
        private let navigationController: UIRoutingNavigationController
        
        init(router: Router) {
            self.router = router
            self.navigationController = router.navigationController
        }
        
        func makeUIViewController(context: Context) -> UIRoutingNavigationController {
            guard router.navigationController.viewControllers.isEmpty else {
                // The navigation controller was already set up, so return
                return navigationController
            }
            
            // Configure the UIRoutingNavigationController reference with the root view controller
            let rootViewController = ViewControllerBuilder.defaultBuilder.buildViewController(forRootRouteOf: router)
            navigationController.viewControllers = [rootViewController]
            
            // Return the configured UIRoutingNavigationController reference
            return navigationController
        }
        
        func updateUIViewController(_ uiViewController: UIRoutingNavigationController, context: Context) {}
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
            // Fallback, on iOS 13.0
            UIKitRoutedContent(router: router)
                .edgesIgnoringSafeArea(.all)
                .routing(with: router)
        }
    }
}
