//
//  IntentAssembly.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 16.03.23.
//

import Swinject

final class IntentAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(HomeIntent.self) { resolver in
            let model = resolver.resolve(HomeModel.self)!
            let repository = resolver.resolve(ShowcaseComponentsRepositoryProtocol.self)!
            let usecase = ShowcaseComponentsUseCase(repository: repository)
            return HomeIntent(model: model, showcaseComponentsUseCase: usecase)
        }.inObjectScope(.weak)
        
        container.register(NavigationBarIntent.self) { resolver in
            return NavigationBarIntent()
        }.inObjectScope(.weak)
        
        container.register(UserDefaultsIntent.self) { resolver in
            let model = resolver.resolve(UserDefaultsModel.self)!
            let preferences = resolver.resolve(Preferences.self)!
            return UserDefaultsIntent(model: model, preferences: preferences)
        }.inObjectScope(.weak)
        
        container.register(RemoteImagesIntent.self) { resolver in
            let model = resolver.resolve(RemoteImagesModel.self)!
            let usecase = resolver.resolve(RemoteImagesUseCaseProtocol.self)!
            return RemoteImagesIntent(model: model, remoteImagesUseCase: usecase)
        }.inObjectScope(.weak)
        
        container.register(LocationAndMapIntent.self) { resolver in
            let model = resolver.resolve(LocationAndMapModel.self)!
            return LocationAndMapIntent(model: model)
        }.inObjectScope(.weak)
        
        container.register(TodoIntent.self) { resolver in
            let model = resolver.resolve(TodoModel.self)!
            let usecase = resolver.resolve(TodoUseCaseProtocol.self)!
            return TodoIntent(model: model, usecase: usecase)
        }.inObjectScope(.weak)
        
        container.register(OpenSafariIntent.self) { resolver in
            let model = resolver.resolve(OpenSafariModel.self)!
            return OpenSafariIntent(model: model)
        }.inObjectScope(.weak)
        
        container.register(OnboardingIntent.self) { resolver in
            let model = resolver.resolve(OnboardingModel.self)!
            return OnboardingIntent(model: model)
        }.inObjectScope(.weak)
        
        container.register(CameraIntent.self) { resolver in
            let model = resolver.resolve(CameraModel.self)!
            return CameraIntent(model: model)
        }.inObjectScope(.weak)
    }
}
