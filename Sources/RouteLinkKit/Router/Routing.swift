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
//  Routing.swift
//  
//
//  Created by Athanasios Kefalas on 18/12/21.
//

import Foundation

/// Any type that can perform routing operations.
public protocol Routing: AnyObject {
    
    /// Restart the current navigation stack by destroying all views including the root view.
    /// - Parameter animated: Transtion animation flag.
    func restart(animated: Bool)
    
    /// Dismiss the top view in the current navigation stack.
    /// - Parameter animated: Transtion animation flag.
    func dismiss(animated: Bool)
    
    
    /// Dismiss all the views in the current navigation stack, until reaching the root view.
    /// - Parameter animated: Transtion animation flag.
    func dismissToRoot(animated: Bool)
}
