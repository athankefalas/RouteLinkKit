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
