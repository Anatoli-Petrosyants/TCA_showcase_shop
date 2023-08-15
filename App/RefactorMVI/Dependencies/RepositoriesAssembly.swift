//
//  RepositoriesAssembly.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Swinject

final class RepositoriesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(ShowcaseComponentsRepositoryProtocol.self) { resolver in            
            return ShowcaseComponentsInMemoryRepository()
        }.inObjectScope(.weak)
        
        container.register(RemoteImagesRepositoryProtocol.self) { resolver in
            return RemoteImagesInMemoryRepository()
        }.inObjectScope(.weak)
        
        container.register(TodoRepositoryProtocol.self) { resolver in
            return TodoLocalRepository()
        }.inObjectScope(.weak)
    }
}

