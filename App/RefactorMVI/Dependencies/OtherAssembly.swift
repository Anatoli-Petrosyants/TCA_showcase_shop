//
//  OtherAssembly.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import Swinject

final class OtherAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(Preferences.self) { resolver in
            return Preferences()
        }.inObjectScope(.weak)
        
        container.register(LocationManagerType.self) { resolver in
            return LocationManager.shared
        }.inObjectScope(.container)
    }
}
