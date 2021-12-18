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
