//
//  LoginOptionsReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.08.23.
//

import SwiftUI
import ComposableArchitecture

struct LoginOptionsReducer: Reducer {
    
    struct State: Equatable {
        var agreementsAttributedString: AttributedString {
            var result = AttributedString("By authorizing you agree our Terms and Conditions and Privacy Policy.")
            
            // We can force unwrap the link range,
            // because we are sure in this case,
            // that `website` string is present.
            let termsRange = result.range(of: "Terms and Conditions")!
            result[termsRange].link = Constant.termsURL
            result[termsRange].underlineStyle = Text.LineStyle(pattern: .solid)
            result[termsRange].foregroundColor = Color.blue
            
            let privacyRange = result.range(of: "Privacy Policy")!
            result[privacyRange].link = Constant.privacyURL
            result[privacyRange].underlineStyle = Text.LineStyle(pattern: .solid)
            result[privacyRange].foregroundColor = Color.blue
            
            return result
        }

        var path = StackState<Path.State>()
        @PresentationState var developedBy: DevelopedByReducer.State?
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onDevelopedByTap
            case onEmailLoginButtonTap
            case onPhoneLoginButtonTap
        }
        
        enum Delegate {
            case didAuthenticated
        }

        case view(ViewAction)
        case delegate(Delegate)
        case developedBy(PresentationAction<DevelopedByReducer.Action>)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case emailLogin(EmailLoginReducer.State = .init())
            case forgotPassword(ForgotPassword.State = .init())
            case phoneLogin(PhoneLoginReducer.State = .init())
            case phoneOTP(PhoneOTPReducer.State = .init())
        }
        
        enum Action: Equatable {
            case emailLogin(EmailLoginReducer.Action)
            case forgotPassword(ForgotPassword.Action)
            case phoneLogin(PhoneLoginReducer.Action)
            case phoneOTP(PhoneOTPReducer.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: /State.emailLogin, action: /Action.emailLogin) {
                EmailLoginReducer()
            }
            
            Scope(state: /State.forgotPassword, action: /Action.forgotPassword) {
                ForgotPassword()
            }
            
            Scope(state: /State.phoneLogin, action: /Action.phoneLogin) {
                PhoneLoginReducer()
            }
            
            Scope(state: /State.phoneOTP, action: /Action.phoneOTP) {
                PhoneOTPReducer()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onEmailLoginButtonTap:
                    state.path.append(.emailLogin(.init()))
                    return .none
                    
                case .onPhoneLoginButtonTap:
                    state.path.append(.phoneLogin(.init()))                    
                    return .none
                    
                case .onDevelopedByTap:
                    state.developedBy = DevelopedByReducer.State()
                    return .none
                }
    
            // path actions
            case let .path(pathAction):
                switch pathAction {
                case .element(id: _, action: .emailLogin(.delegate(.didEmailAuthenticated))):
                    return .send(.delegate(.didAuthenticated))
                    
                case .element(id: _, action: .emailLogin(.delegate(.didForgotPasswordPressed))):
                    state.path.append(.forgotPassword(.init()))
                    return .none
                    
                case .element(id: _, action: .forgotPassword(.delegate(.didPasswordChanged))):
                    _ = state.path.popLast()
                    return .none
                    
                case .element(id: _, action: .phoneLogin(.delegate(.didPhoneAuthenticated))):
                    state.path.append(.phoneOTP(.init()))
                    return .none
                    
                case .element(id: _, action: .phoneOTP(.delegate(.didCodeAuthenticated))):                    
                    return .send(.delegate(.didAuthenticated))

                default:
                    return .none
                }
                
            // #dev Here we will try to implement analytics client. A.P.
            case let .developedBy(.presented(.delegate(developedByAction))):
                switch developedByAction {
                case .didDevelopedByViewed:
                    Log.info("delegate didDevelopedByViewed")
                    return .none
                }
                
            case .developedBy(.dismiss):
                return .none
                            
            case .developedBy, .delegate:
                return .none
            }
        }
        .ifLet(\.$developedBy, action: /Action.developedBy) { DevelopedByReducer() }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
