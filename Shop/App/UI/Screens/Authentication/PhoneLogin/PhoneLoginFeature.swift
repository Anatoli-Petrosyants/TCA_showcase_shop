//
//  PhoneLoginFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.08.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct PhoneLoginFeature {
    
    @ObservableState
    struct State: Equatable {
        var number = ""
        var isContinueButtonDisabled = true
        var isActivityIndicatorVisible = false
    }
    
    enum Action: Equatable, BindableAction {
        enum ViewAction: Equatable {
            case onContinueButtonTap
        }
        
        enum Delegate {
            case didPhoneAuthenticated
        }
        
        case view(ViewAction)
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onContinueButtonTap:
                    state.isActivityIndicatorVisible = true
                    return .run { send in
                        try await self.clock.sleep(for: .seconds(2))
                        await send(.delegate(.didPhoneAuthenticated))
                    }
                }

            case .binding(\.number):
                state.isContinueButtonDisabled = !(state.number.count > 0)
                return .none
                
            case .binding:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
