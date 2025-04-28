//
//  PropertyWrapper.swift
//  DIContainer
//
//  Created by junky on 2025/4/28.
//

import Foundation

@MainActor
@propertyWrapper
public struct Inject<T> {
    
    
    public var wrappedValue: T? {
        var res: T? = nil
        do {
            res = try container.resolve(interface: T.self)
        } catch {
            print(error.localizedDescription)
        }
        return res
    }
    
    var container: DIContainer
    
    
    public init(container: DIContainer? = nil) {
        self.container = container ?? .shared
    }
}

