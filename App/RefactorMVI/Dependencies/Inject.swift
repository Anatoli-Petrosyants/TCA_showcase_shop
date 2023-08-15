//
//  Injected.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 01.03.23.
//

import Swinject

@propertyWrapper
struct Inject<T> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = SwinjectDependency.shared.resolver.resolve(T.self)!
    }
}
