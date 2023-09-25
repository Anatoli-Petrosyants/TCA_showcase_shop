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
    let store: StoreOf<AppReducer>
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
                CaseLet(/AppReducer.State.loading, action: AppReducer.Action.loading) { store in
                    LoadingView(store: store)
                        .transition(.delayAndFade)
                }
                
            case .onboarding:
                CaseLet(/AppReducer.State.onboarding, action: AppReducer.Action.help) { store in
                    OnboardingView(store: store)
                        .transition(.delayAndFade)
                }
                
            case .join:
                CaseLet(/AppReducer.State.join, action: AppReducer.Action.join) { store in
                    JoinView(store: store)
                        .transition(.delayAndFade)
                }
                
            case .main:
                CaseLet(/AppReducer.State.main, action: AppReducer.Action.main) { store in
                    MainView(store: store)
                        .transition(.delayAndFade)
                }
            }
        }
    }
}
