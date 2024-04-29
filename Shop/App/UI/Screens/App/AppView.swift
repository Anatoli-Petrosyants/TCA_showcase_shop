//
//  RootView.swift
//  App
//
//  Created by Anatoli Petrosyants on 10.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - HelpView

struct AppView {
    let store: StoreOf<AppFeature>
}

// MARK: - Views

extension AppView: View {
    
    var body: some View {
        content
    }

    @ViewBuilder private var content: some View {
        switch store.state {
        case .loading:
            if let store = store.scope(state: \.loading, action: \.loading) {
                LoadingView(store: store)
                    .transition(.delayAndFade)
            }
        case .onboarding:
            if let store = store.scope(state: \.onboarding, action: \.onboarding) {
                OnboardingView(store: store)
                    .transition(.delayAndFade)
            }
        case .join:
            if let store = store.scope(state: \.join, action: \.join) {
                JoinView(store: store)
                    .transition(.delayAndFade)
            }
        case .main:
            if let store = store.scope(state: \.main, action: \.main) {
                MainView(store: store)
                    .transition(.delayAndFade)
            }
        }
    }
}
