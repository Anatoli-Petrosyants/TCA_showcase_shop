//
//  UserDefaultsIntent.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.03.23.
//

import SwiftUI
import Combine

protocol UserDefaultsIntentProtocol {
    typealias Action = UserDefaultsIntent.Action
    func execute(action: Action)
}

final class UserDefaultsIntent {
    
    private weak var model: UserDefaultsModelActionsProtocol?
    private var preferences: Preferences
    
    private var lineWrappingCancellable: AnyCancellable?
    
    init(model: UserDefaultsModelActionsProtocol, preferences: Preferences) {
        self.model = model
        self.preferences = preferences
    }
}

// MARK: Actions

extension UserDefaultsIntent {
    enum Action {
        case onViewApear
        case onShowOnboardingTap
        case onResetTap
    }
}

extension UserDefaultsIntent: UserDefaultsIntentProtocol {
    
    func execute(@Debuggable(description: "UserDefaultsIntent action") action: Action) {
        switch action {
        case .onViewApear:
            processOnViewApear()
        case .onShowOnboardingTap:
            preferences.hasAppOnboardingShown = true
        case .onResetTap:
            preferences.hasAppOnboardingShown = false
        }
    }
}

// MARK: Helpers

private extension UserDefaultsIntent {
    
    func processOnViewApear() {
        lineWrappingCancellable = preferences.$hasAppOnboardingShown
            .dropFirst()
            .sink { [weak self] isEnabled in
                print(isEnabled)
                self?.model?.mutate(action: .showOnboardingAlert(isEnabled))
            }
    }
}
