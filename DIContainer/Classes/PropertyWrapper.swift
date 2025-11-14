//
//  PropertyWrapper.swift
//  DIContainer
//
//  Created by junky on 2025/4/28.
//

import Foundation


@propertyWrapper
public class Inject<T> {
    
    
    public var wrappedValue: T? {
        if cache {
            guard cacheInstance == nil else {
                return cacheInstance
            }
        }
        var res: T? = nil
        do {
            res = try container.resolve(interface: T.self)
            cacheInstance = res
        } catch {
            print(error.localizedDescription)
        }
        return res
    }
    
    var container: DIContainer
    
    var cacheInstance: T?
    
    var cache: Bool
    
    public init(container: DIContainer = .shared, cache: Bool = true) {
        self.container = container
        self.cache = cache
    }
}


@propertyWrapper
public class InjectDefault<T> {
    
    
    public var wrappedValue: T {
        if cache {
            if let instance = cacheInstance {
                return instance
            }
        }
        var res: T? = nil
        do {
            res = try container.resolve(interface: T.self)
            cacheInstance = res
        } catch {
            print(error.localizedDescription)
        }
        if let res = res {
            return res
        }
        return defoult
    }
    
    var container: DIContainer
    
    var cacheInstance: T?
    
    var cache: Bool
    
    var defoult: T
    
    public init(container: DIContainer = .shared, cache: Bool = true, defoult: T) {
        self.container = container
        self.cache = cache
        self.defoult = defoult
    }
}
