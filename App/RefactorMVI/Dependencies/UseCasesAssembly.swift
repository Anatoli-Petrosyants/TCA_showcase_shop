//
//  UseCasesAssembly.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Swinject

final class UseCasesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(ShowcaseComponentsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ShowcaseComponentsRepositoryProtocol.self)!
            let usecase = ShowcaseComponentsUseCase(repository: repository)
            return usecase
        }.inObjectScope(.weak)
        
        container.register(RemoteImagesUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(RemoteImagesRepositoryProtocol.self)!
            let usecase = RemoteImagesUseCase(repository: repository)
            return usecase
        }.inObjectScope(.weak)
        
        container.register(TodoUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(TodoRepositoryProtocol.self)!
            let usecase = TodoUseCase(repository: repository)
            return usecase
        }.inObjectScope(.weak)
    }
}
