//
//  CameraIntent.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 03.04.23.
//

import SwiftUI

protocol CameraIntentProtocol {
    typealias Action = CameraIntent.Action
    func execute(action: Action)
}

final class CameraIntent {
    
    private weak var model: CameraModelActionsProtocol?
    
    init(model: CameraModelActionsProtocol) {
        self.model = model
    }
}

// MARK: Actions

extension CameraIntent {
    enum Action {
        case onViewApear
    }
}

extension CameraIntent: CameraIntentProtocol {
    
    func execute(action: Action) {
        switch action {
        case .onViewApear:
            break
        }
    }
}

// MARK: Helpers

private extension CameraIntent {
    
}
