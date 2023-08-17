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
        
        enum DestinationAction: Equatable {
            case pop
        }
        
        enum AlertAction: Equatable {
            case confirmPasswordChange
        }
        
        case view(ViewAction)
        case alert(PresentationAction<AlertAction>)
        case destination(DestinationAction)
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
                return .send(.destination(.pop))
                
            case .destination, .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}
