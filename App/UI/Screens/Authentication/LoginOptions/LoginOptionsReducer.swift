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
        @PresentationState var agreements: Agreements.State?
    }
    
    enum Action: Equatable {
        case onAgreementsTap
        case onEmailLoginButtonTap
        case agreements(PresentationAction<Agreements.Action>)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case emailLogin(EmailLoginReducer.State = .init())
        }
        
        enum Action: Equatable {
            case emailLogin(EmailLoginReducer.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: /State.emailLogin, action: /Action.emailLogin) {
                EmailLoginReducer()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onEmailLoginButtonTap:
                state.path.append(.emailLogin(.init()))
                return .none
                
            case .onAgreementsTap:
                state.agreements = Agreements.State()
                return .none
                
            case let .agreements(.presented(.delegate(agreementsAction))):
                switch agreementsAction {
                case .didAgreementsAccepted:
                    Log.info("delegate didAgreementsAccepted")
                    return .none
                }
                
            case .agreements(.dismiss):
                return .none
                            
            case .agreements, .path:
                return .none
            }
        }
        .ifLet(\.$agreements, action: /Action.agreements) { Agreements() }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
