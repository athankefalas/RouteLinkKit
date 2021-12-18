//
//  Routing.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation

public protocol Routing: AnyObject {
    /// Restart the current navigation stack by destroying all views including the root view.
    /// - Parameter animated: Transtion animation flag
    func restart(animated: Bool)
    
    /// Dismiss the top view in the current navigation stack
    /// - Parameter animated: Transtion animation flag
    func dismiss(animated: Bool)
    
    
    /// Dismiss all the views in the current navigation stack, until reaching the root view.
    /// - Parameter animated: Transtion animation flag
    func dismissToRoot(animated: Bool)
}
