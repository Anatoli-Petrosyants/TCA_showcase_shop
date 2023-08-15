//
//  OpenSafariIntent.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

protocol OpenSafariIntentProtocol {
    typealias Action = OpenSafariIntent.Action
    func execute(action: Action)
}

final class OpenSafariIntent {
    
    private weak var model: OpenSafariModelActionsProtocol?
    
    init(model: OpenSafariModelActionsProtocol) {
        self.model = model
    }
}

// MARK: Actions

extension OpenSafariIntent {
    enum Action {
        case onViewApear
    }
}

extension OpenSafariIntent: OpenSafariIntentProtocol {
    
    func execute(action: Action) {
        switch action {
        case .onViewApear:
            break
        }
    }
}

// MARK: Helpers

private extension OpenSafariIntent {
    
}
