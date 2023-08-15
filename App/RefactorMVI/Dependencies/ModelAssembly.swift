//
//  ModelAssembly.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.03.23.
//

import Swinject

final class ModelAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(HomeModel.self) { resolver in
            return HomeModel()
        }.inObjectScope(.weak)
        
        container.register(UserDefaultsModel.self) { resolver in
            return UserDefaultsModel()
        }.inObjectScope(.weak)
        
        container.register(RemoteImagesModel.self) { resolver in
            return RemoteImagesModel()
        }.inObjectScope(.weak)
        
        container.register(LocationAndMapModel.self) { resolver in
            return LocationAndMapModel()
        }.inObjectScope(.weak)
        
        container.register(TodoModel.self) { resolver in
            return TodoModel()
        }.inObjectScope(.weak)
        
        container.register(OpenSafariModel.self) { resolver in
            return OpenSafariModel()
        }.inObjectScope(.weak)
        
        container.register(OnboardingModel.self) { resolver in
            return OnboardingModel()
        }.inObjectScope(.weak)
        
        container.register(CameraModel.self) { resolver in
            return CameraModel()
        }.inObjectScope(.weak)
    }
}
