//
//  RemoteImagesIntent.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import SwiftUI

protocol RemoteImagesIntentProtocol {
    typealias Action = RemoteImagesIntent.Action
    func execute(action: Action)
}

final class RemoteImagesIntent {
    
    private weak var model: RemoteImagesModelActionsProtocol?
    private var remoteImagesUseCase: RemoteImagesUseCaseProtocol
    
    init(model: RemoteImagesModelActionsProtocol, remoteImagesUseCase: RemoteImagesUseCaseProtocol) {
        self.model = model
        self.remoteImagesUseCase = remoteImagesUseCase
    }
}

// MARK: Actions

extension RemoteImagesIntent {
    enum Action {
        case onViewApear
    }
}

extension RemoteImagesIntent: RemoteImagesIntentProtocol {
    
    func execute(action: Action) {
        switch action {
        case .onViewApear:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.processOnViewApear()
            }
        }
    }
}

// MARK: Helpers

private extension RemoteImagesIntent {
    
    func processOnViewApear() {
        remoteImagesUseCase.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let list = data, !list.isEmpty else {
                    self.model?.mutate(action: .failed(error: AppError.general))
                    return
                }

                let vms = list.enumerated().map { (index, element) in
                    return RemoteImagesCardViewModel(index: index, path: element.path)
                }
                
                self.model?.mutate(action: .success(data: vms))
                                
            case .failure(let error):
                self.model?.mutate(action: .failed(error: error))
            }
        }
    }
}
