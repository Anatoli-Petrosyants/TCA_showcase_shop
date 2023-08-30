//
//  ForgotPassword.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 21.06.23.
//

import SwiftUI
import ComposableArchitecture

struct ForgotPassword: Reducer {
    
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.AlertAction>?
    }
    
    enum Action: Equatable {        
        enum ViewAction: Equatable {
            case onChangePasswordButtonTap
        }
        
        enum DelegateAction: Equatable {
            case didPasswordChanged
        }
        
        enum AlertAction: Equatable {
            case confirmPasswordChange
        }
        
        case view(ViewAction)
        case alert(PresentationAction<AlertAction>)
        case delegate(DelegateAction)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onChangePasswordButtonTap:
                    state.alert = AlertState {
                        TextState(Localization.Base.areYouSure)
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmPasswordChange) {
                            TextState(Localization.ForgotPassword.changePassword)
                        }
                    }
                    return .none
                }
                
            case .alert(.presented(.confirmPasswordChange)):
                return .send(.delegate(.didPasswordChanged))
                
            case .delegate, .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}
