//
//  EmailLoginFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.04.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct EmailLoginFeature {
    
    @ObservableState
    struct State: Equatable {
        var isActivityIndicatorVisible = false
        var username = "mor_2314"
        var password = "83r5^_"
        
        @Presents var alert: AlertState<Never>?
    }
    
    enum Action: Equatable, BindableAction {
        enum ViewAction: Equatable {
            case onSignInButtonTap
            case onForgotPasswordButtonTap
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
        case binding(BindingAction<State>)
        case alert(PresentationAction<Never>)
    }
    
    private enum CancelID { case login }
    
    @Dependency(\.authenticationClient) var authenticationClient
    @Dependency(\.userKeychainClient) var userKeychainClient
    @Dependency(\.databaseClient) var databaseClient

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {                    
                case .onSignInButtonTap:
                    state.isActivityIndicatorVisible = true
                    return .run { [username = state.username, password = state.password] send in
                        await send(
                            .internal(
                                .loginResponse(
                                    await TaskResult {
                                        try await self.authenticationClient.login(
                                            .init(username: username, password: password)
                                        )
                                    }
                                )
                            )
                        )
                    }
                    .cancellable(id: CancelID.login)
                    
                case .onForgotPasswordButtonTap:
                    return .send(.delegate(.didForgotPasswordPressed))
                }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .loginResponse(.success(data)):
                    Log.info("loginResponse: \(data)")
                    state.isActivityIndicatorVisible = false
                    userKeychainClient.storeToken(data.token)
                    return .concatenate(
                        .run { _ in
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
                
            case .binding:
                return .none
            }
        }        
        .ifLet(\.$alert, action: /Action.alert)
    }
}
