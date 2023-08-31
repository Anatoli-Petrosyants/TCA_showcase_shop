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
    }
    
    enum Action: Equatable {
        enum ViewAction: BindableAction, Equatable {
            case onContinueButtonTap
            case binding(BindingAction<State>)
        }
        
        case view(ViewAction)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: /Action.view)
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onContinueButtonTap:                    
                    return .none
    
                case .binding(\.$number):
                    state.isContinueButtonDisabled = !(state.number == Constant.validPhoneNumber)
                    return .none
                    
                case .binding:
                    return .none
                }
            }
        }
    }
}
