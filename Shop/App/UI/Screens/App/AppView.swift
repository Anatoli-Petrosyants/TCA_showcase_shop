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
        SwitchStore(self.store) { state in
            switch state {
            case .loading:
                CaseLet(/AppFeature.State.loading, action: AppFeature.Action.loading) { store in
                    LoadingView(store: store)
                        .transition(.delayAndFade)
                }
                
            case .onboarding:
                CaseLet(/AppFeature.State.onboarding, action: AppFeature.Action.help) { store in
                    OnboardingView(store: store)
                        .transition(.delayAndFade)
                }
                
            case .join:
                CaseLet(/AppFeature.State.join, action: AppFeature.Action.join) { store in
                    JoinView(store: store)
                        .transition(.delayAndFade)
                }
                
            case .main:
                CaseLet(/AppFeature.State.main, action: AppFeature.Action.main) { store in
                    MainView(store: store)
                        .transition(.delayAndFade)
                }
            }
        }
    }
}
