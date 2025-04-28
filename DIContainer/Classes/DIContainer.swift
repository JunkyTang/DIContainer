//
//  DIContainer.swift
//  DIContainer
//
//  Created by junky on 2025/4/26.
//

import Foundation

@MainActor
public class DIContainer {
    
    public static let shared = DIContainer()
    
    private var modules: [ObjectIdentifier: Any]
    private init(modules: [ObjectIdentifier : Any] = [:]) {
        self.modules = modules
    }
    
    
    public func register<T>(interface: T.Type, impl: T) throws {
        let key = ObjectIdentifier(interface)
        if let _ = modules[key] {
            throw Exception.duplicateRegistration
        }
        modules[key] = impl
    }
    
    public func resolve<T>(interface: T.Type) throws -> T {
        let key = ObjectIdentifier(interface)
        guard let impl = modules[key] as? T else { throw Exception.moduleNotFound }
        return impl
    }
    
    // New function to clear all modules
    public func clearModules() {
        modules.removeAll()
    }
}
