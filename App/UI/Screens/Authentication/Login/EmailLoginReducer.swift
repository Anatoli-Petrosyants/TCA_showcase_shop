//
//  LoginReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.04.23.
//

import SwiftUI
import ComposableArchitecture

struct EmailLoginReducer: Reducer {
    
    struct State: Equatable {
        @BindingState var isActivityIndicatorVisible = false
        @BindingState var email: String = "mor_2314"
        @BindingState var password: String = "83r5^_"
        @PresentationState var alert: AlertState<Never>?
    }
    
    enum Action: Equatable {
        enum ViewAction: BindableAction, Equatable {
            case onSignInButtonTap            
            case onForgotPasswordButtonTap
            case binding(BindingAction<State>)
        }
        
        enum InternalAction: Equatable {
            case loginResponse(TaskResult<AuthenticationResponse>)
        }
        
        enum Delegate {
            case didEmailAuthenticated
            case didForgotPasswordPressed
        }
        
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case alert(PresentationAction<Never>)
    }
    
    private enum CancelID { case login }
    
    @Dependency(\.authenticationClient) var authenticationClient
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.databaseClient) var databaseClient

    var body: some Reducer<State, Action> {
        BindingReducer(action: /Action.view)
        
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {                    
                case .onSignInButtonTap:
                    state.isActivityIndicatorVisible = true
                    return .run { [email = state.email, password = state.password] send in
                        await send(
                            .internal(
                                .loginResponse(
                                    await TaskResult {
                                        try await self.authenticationClient.login(
                                            .init(email: email, password: password)
                                        )
                                    }
                                )
                            )
                        )
                    }
                    .cancellable(id: CancelID.login)
                    
                case .onForgotPasswordButtonTap:
                    return .send(.delegate(.didForgotPasswordPressed))
                    
                case .binding:
                    return .none
                }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .loginResponse(.success(data)):
                    Log.info("loginResponse: \(data)")
                    state.isActivityIndicatorVisible = false
                    return .concatenate(
                        .run { _ in
                            await self.userDefaults.setToken(data.token)

                            let account = Account(token: data.token)
                            try await self.databaseClient.insert(account)
                        },
                        .send(.delegate(.didEmailAuthenticated))
                    )
                    
                case let .loginResponse(.failure(error)):
                    Log.error("loginResponse: \(error)")
                    state.isActivityIndicatorVisible = false
                    state.alert = AlertState { TextState(error.localizedDescription) }
                    return .none
                }
                            
            case .delegate, .alert:
                return .none
            }
        }        
        .ifLet(\.$alert, action: /Action.alert)
    }
}
