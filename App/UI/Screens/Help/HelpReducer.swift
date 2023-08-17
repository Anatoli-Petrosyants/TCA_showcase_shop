//
//  HelpReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 10.04.23.
//

import SwiftUI
import ComposableArchitecture

struct HelpReducer: Reducer {
    
    struct State: Equatable, Hashable {
        var items: [Onboarding] = Onboarding.pages
        @BindingState var currentTab: Onboarding.Tab = .page1        
        var showGetStarted = false
    }
    
    enum Action: Equatable {
        enum ViewAction: BindableAction, Equatable {
            case onViewAppear
            case onGetStartedTapped
            case onTabChanged(tab: Onboarding.Tab)
            case binding(BindingAction<State>)
        }
        
        enum Delegate {
            case didOnboardingFinished
        }
        
        case view(ViewAction)
        case delegate(Delegate)
    }
    
    @Dependency(\.userDefaults) var userDefaults
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: /Action.view)
        
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onViewAppear:
                    return .none
                    
                case .onGetStartedTapped:
                    return .concatenate(
                        .send(.delegate(.didOnboardingFinished)),
                        .run { _ in
                            await self.userDefaults.setHasShownFirstLaunchOnboarding(true)
                        }
                    )
                    
                case let .onTabChanged(tab):
                    state.showGetStarted = (tab == .page3)
                    return .none
                    
                case .binding:
                    return .none
                }
                
            case .delegate:
                return .none
            }
        }
    }
}


