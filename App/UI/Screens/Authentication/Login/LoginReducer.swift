//
//  Login.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.04.23.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation
import Dependencies

struct LoginReducer: ReducerProtocol {
    
    struct State: Equatable {
        @BindingState var isActivityIndicatorVisible = false

        @BindingState var email: String = "mor_2314"
        @BindingState var password: String = "83r5^_"
        
        var path = StackState<Path.State>()
        @PresentationState var agreements: Agreements.State?
        @PresentationState var alert: AlertState<Never>?
    }
    
    enum Action: BindableAction, Equatable {
        enum ViewAction: Equatable {
            case onSignInButtonTap
            case onAgreementsTap
            case onForgotPasswordButtonTap
        }
        
        enum InternalAction: Equatable {
            case loginResponse(TaskResult<AuthenticationResponse>)
        }
        
        enum Delegate {
            case didAuthenticated
        }
        
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case path(StackAction<Path.State, Path.Action>)
        case agreements(PresentationAction<Agreements.Action>)
        case alert(PresentationAction<Never>)
        case binding(BindingAction<State>)
    }
    
    struct Path: ReducerProtocol {
        enum State: Equatable {
            case forgotPassword(ForgotPassword.State = .init())
        }
        
        enum Action: Equatable {
            case forgotPassword(ForgotPassword.Action)
        }
        
        var body: some ReducerProtocol<State, Action> {
            Scope(state: /State.forgotPassword, action: /Action.forgotPassword) {
                ForgotPassword()
            }
        }
    }
    
    private enum CancelID { case login }
    
    @Dependency(\.authenticationClient) var authenticationClient
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.databaseClient) var databaseClient

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
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
                    
                case .onAgreementsTap:
                    state.agreements = Agreements.State()
                    return .none
                    
                case .onForgotPasswordButtonTap:
                    state.path.append(.forgotPassword(.init()))                    
                    return .cancel(id: CancelID.login)
                }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .loginResponse(.success(data)):
                    Log.debug("loginResponse: \(data)")
                    state.isActivityIndicatorVisible = false
                    return .concatenate(
                        .fireAndForget {
                            await self.userDefaults.setToken(data.token)

                            let account = Account(token: data.token)
                            try await self.databaseClient.insert(account)
                        },
                        .send(.delegate(.didAuthenticated))
                    )
                    
                case let .loginResponse(.failure(error)):
                    state.isActivityIndicatorVisible = false
                    state.alert = AlertState { TextState(error.localizedDescription) }
                    return .none
                }
                
            // path actions
            case let .path(pathAction):
                switch pathAction {
                case .element(id: _, action: .forgotPassword(.destination(.pop))):
                    state.path.removeAll()
                    return .none
                    
                default:
                    return .none
                }
                
            case let .agreements(.presented(.delegate(agreementsAction))):
                switch agreementsAction {
                case .didAgreementsAccepted:
                    Log.debug("delegate didAgreementsAccepted")
                    return .none
                }
                
            case .agreements(.dismiss):
                Log.debug("agreements dismiss")
                return .none
                            
            case .agreements, .delegate, .alert, .binding:
                return .none
            }
        }
        .ifLet(\.$agreements, action: /Action.agreements) { Agreements() }
        .ifLet(\.$alert, action: /Action.alert)
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
