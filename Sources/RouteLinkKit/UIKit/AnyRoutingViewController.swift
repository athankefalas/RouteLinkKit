//
//  AnyRoutingViewController.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation

/// A type representing a view controller that can present a route.
public protocol AnyRoutingViewController: AnyObject {
    /// Returns whether or not this view controller instance  is currently presenting the specified route.
    /// - Returns: Whether or not the specified route is being presented
    func isPresenting<SomeRoute: RouteRepresenting>(route: SomeRoute) -> Bool
}
