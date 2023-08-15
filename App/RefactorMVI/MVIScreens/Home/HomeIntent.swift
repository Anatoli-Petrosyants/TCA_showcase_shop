//
//  HomeIntent.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.03.23.
//

import SwiftUI

protocol HomeIntentProtocol {
    typealias Action = HomeIntent.Action
    func execute(action: Action)
}

final class HomeIntent {
    
    // MARK: Private
    private weak var model: HomeModelActionsProtocol?
    private let showcaseComponentsUseCase: ShowcaseComponentsUseCaseProtocol

    init(model: HomeModelActionsProtocol, showcaseComponentsUseCase: ShowcaseComponentsUseCaseProtocol) {
        self.model = model
        self.showcaseComponentsUseCase = showcaseComponentsUseCase
    }
}

// MARK: Actions

extension HomeIntent {
    enum Action {
        case onViewApear
        case itemTapped(_ component: Component, _ route: Block<any View>)
    }
}

extension HomeIntent: HomeIntentProtocol {
    
    func execute(action: Action) {
        switch action {
        case .onViewApear:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.processOnViewApear()
            }
            
        case let .itemTapped(component, block):
            switch component.type {
            case .navigationBar:
                block(SwinjectDependency.shared.resolver.resolve(NavigationBarView.self)!)
            case .userdefaults:
                block(SwinjectDependency.shared.resolver.resolve(UserDefaultsView.self)!)
            case .remoteImages:
                block(SwinjectDependency.shared.resolver.resolve(RemoteImagesView.self)!)
            case .locationAndMap:
                block(SwinjectDependency.shared.resolver.resolve(LocationAndMapView.self)!)
            case .todo:
                block(SwinjectDependency.shared.resolver.resolve(TodoView.self)!)
            case .openSafari:
                block(SwinjectDependency.shared.resolver.resolve(OpenSafariView.self)!)
            case .onboarding:
                block(SwinjectDependency.shared.resolver.resolve(OnboardingView.self)!)
            case .camera:
                block(SwinjectDependency.shared.resolver.resolve(CameraV1View.self)!)
            default: break
            }
        }
    }
}

// MARK: Helpers

private extension HomeIntent {
    
    func processOnViewApear() {
        showcaseComponentsUseCase.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let list = data, !list.isEmpty else {
                    self.model?.mutate(action: .failed(error: AppError.general))
                    return
                }
                
                self.model?.mutate(action: .success(data: list))
                                
            case .failure(let error):
                self.model?.mutate(action: .failed(error: error))
            }
        }
    }
}
