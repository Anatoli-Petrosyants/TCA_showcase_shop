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
        var path = StackState<Path.State>()
    }
    
    enum Action: Equatable {
        case onEmailLoginButtonTap
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
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
