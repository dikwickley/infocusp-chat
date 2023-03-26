//
//  DependencyManager.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 07/02/23.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        register { FirebaseManager() }
    }
}
