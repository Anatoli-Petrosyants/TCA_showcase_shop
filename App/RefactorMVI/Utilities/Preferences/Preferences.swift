//
//  Preferences.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import SwiftUI
import Combine

struct Preferences {
    private enum Key {
        static let hasAppOnboardingShown = "has_app_onboarding_shown"
    }

    @UserDefault(Preferences.Key.hasAppOnboardingShown) var hasAppOnboardingShown = false
}
