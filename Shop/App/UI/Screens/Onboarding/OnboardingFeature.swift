//
//  OnboardingFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 10.04.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct OnboardingFeature {
    
    @ObservableState
    struct State: Equatable, Hashable {
        var items: [Onboarding] = Onboarding.pages
        var selectedTab: Onboarding.Tab = .page1
        var showGetStarted = false
    }
    
    enum Action: Equatable, BindableAction {
        enum Delegate {
            case didOnboardingFinished
        }
        
        case onGetStartedTapped
        // case onTabChanged(tab: Onboarding.Tab)
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onGetStartedTapped:
                return .concatenate(
                    .run { _ in
                        await self.userDefaultsClient.setHasShownFirstLaunchOnboarding(true)
                    },
                    .send(.delegate(.didOnboardingFinished))
                )
                
//            case let .onTabChanged(tab):
//                state.selectedTab = tab
//                state.showGetStarted = (tab == .page3)
//                return .none
                
            case .binding(\.selectedTab):
                state.showGetStarted = (state.selectedTab == .page3)
                return .none
                
            case .binding:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}

