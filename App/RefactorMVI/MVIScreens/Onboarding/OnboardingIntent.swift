//
//  OnboardingIntent.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

protocol OnboardingIntentProtocol {
    typealias Action = OnboardingIntent.Action
    func execute(action: Action)
}

final class OnboardingIntent {
    
    private weak var model: OnboardingModelActionsProtocol?
    
    init(model: OnboardingModelActionsProtocol) {
        self.model = model
    }
}

// MARK: Actions

extension OnboardingIntent {
    enum Action {
        case onViewApear
    }
}

extension OnboardingIntent: OnboardingIntentProtocol {
    
    func execute(action: Action) {
        switch action {
        case .onViewApear:
            Log.debug("onViewApear \(Onboarding.pages)")
        }
    }
}

// MARK: Helpers

private extension OnboardingIntent {
    
}
