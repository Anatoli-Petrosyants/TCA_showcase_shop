//
//  PhoneLoginReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.08.23.
//

import SwiftUI
import ComposableArchitecture

struct PhoneLoginReducer: Reducer {
    
    struct State: Equatable {
        @BindingState var number = ""
        var isContinueButtonDisabled = true
        var isActivityIndicatorVisible = false
    }
    
    enum Action: Equatable {
        enum ViewAction: BindableAction, Equatable {
            case onContinueButtonTap
            case binding(BindingAction<State>)
        }
        
        enum Delegate {
            case didPhoneAuthenticated
        }
        
        case view(ViewAction)
        case delegate(Delegate)
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: /Action.view)
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onContinueButtonTap:
                    state.isActivityIndicatorVisible = true
                    return .run { send in
                        try await self.clock.sleep(for: .milliseconds(4))
                        await send(.delegate(.didPhoneAuthenticated))
                    }
    
                case .binding(\.$number):
                    state.isContinueButtonDisabled = !(state.number == Constant.validPhoneNumber)
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
