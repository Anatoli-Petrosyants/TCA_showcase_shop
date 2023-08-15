//
//  ViewsAssembly.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Swinject
import SwiftUI

final class ViewsAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(HomeView.self) { resolver in            
            let model = resolver.resolve(HomeModel.self)!
            let intent = resolver.resolve(HomeIntent.self)!
            let container = MVIContainer2(
                intent: intent as HomeIntentProtocol,
                model: model as HomeModelStatePotocol,
                modelChangePublisher: model.objectWillChange)
            let view = HomeView(container: container)
            return view
        }.inObjectScope(.weak)
        
        container.register(NavigationBarView.self) { resolver in
            let intent = resolver.resolve(NavigationBarIntent.self)!
            let view = NavigationBarView(container: .init(
                intent: intent,
                state: intent.state,
                modelChangePublisher: intent.objectWillChange))
            return view
        }.inObjectScope(.weak)
        
        container.register(UserDefaultsView.self) { resolver in
            let model = resolver.resolve(UserDefaultsModel.self)!
            let intent = resolver.resolve(UserDefaultsIntent.self)!
            let container = MVIContainer2(
                intent: intent as UserDefaultsIntentProtocol,
                model: model as UserDefaultsModelStatePotocol,
                modelChangePublisher: model.objectWillChange)
            let view = UserDefaultsView(container: container)
            return view
        }.inObjectScope(.weak)
        
        container.register(RemoteImagesView.self) { resolver in
            let model = resolver.resolve(RemoteImagesModel.self)!
            let intent = resolver.resolve(RemoteImagesIntent.self)!
            let container = MVIContainer2(
                intent: intent as RemoteImagesIntentProtocol,
                model: model as RemoteImagesModelStatePotocol,
                modelChangePublisher: model.objectWillChange)
            let view = RemoteImagesView(container: container)
            return view
        }.inObjectScope(.weak)
        
        container.register(LocationAndMapView.self) { resolver in
            let model = resolver.resolve(LocationAndMapModel.self)!
            let intent = resolver.resolve(LocationAndMapIntent.self)!
            let container = MVIContainer2(
                intent: intent as LocationAndMapIntentProtocol,
                model: model as LocationAndMapModelStatePotocol,
                modelChangePublisher: model.objectWillChange)
            let view = LocationAndMapView(container: container)
            return view
        }.inObjectScope(.weak)
        
        container.register(TodoView.self) { resolver in
            let model = resolver.resolve(TodoModel.self)!
            let intent = resolver.resolve(TodoIntent.self)!
            let container = MVIContainer2(
                intent: intent as TodoIntentProtocol,
                model: model as TodoModelStatePotocol,
                modelChangePublisher: model.objectWillChange)
            let view = TodoView(container: container)
            return view
        }.inObjectScope(.weak)
        
        container.register(OpenSafariView.self) { resolver in
            let model = resolver.resolve(OpenSafariModel.self)!
            let intent = resolver.resolve(OpenSafariIntent.self)!
            let container = MVIContainer2(
                intent: intent as OpenSafariIntentProtocol,
                model: model as OpenSafariModelStatePotocol,
                modelChangePublisher: model.objectWillChange)
            let view = OpenSafariView(container: container)
            return view
        }.inObjectScope(.weak)
        
        container.register(OnboardingView.self) { resolver in
            let model = resolver.resolve(OnboardingModel.self)!
            let intent = resolver.resolve(OnboardingIntent.self)!
            let container = MVIContainer2(
                intent: intent as OnboardingIntentProtocol,
                model: model as OnboardingModelStatePotocol,
                modelChangePublisher: model.objectWillChange)
            let view = OnboardingView(container: container)
            return view
        }.inObjectScope(.weak)
        
        container.register(CameraV1View.self) { resolver in
            let model = resolver.resolve(CameraModel.self)!
            let intent = resolver.resolve(CameraIntent.self)!
            let container = MVIContainer2(
                intent: intent as CameraIntentProtocol,
                model: model as CameraModelStatePotocol,
                modelChangePublisher: model.objectWillChange)
            let view = CameraV1View(container: container)
            return view
        }.inObjectScope(.weak)
    }
}
