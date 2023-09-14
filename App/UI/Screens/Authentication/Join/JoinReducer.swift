//
//  JoinReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.08.23.
//

import SwiftUI
import ComposableArchitecture
import AuthenticationServices

struct JoinReducer: Reducer {
    
    struct State: Equatable {
        var path = StackState<Path.State>()
        @PresentationState var developedBy: DevelopedByReducer.State?
        @PresentationState var loginOptions: LoginOptionsReducer.State?
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onDevelopedByTap
            case onJoinButtonTap
        }
        
        enum Delegate {
            case didAuthenticated
        }
        
        enum InternalAction: Equatable {            
            case authorizationResponse(TaskResult<ASAuthorization>)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case developedBy(PresentationAction<DevelopedByReducer.Action>)
        case loginOptions(PresentationAction<LoginOptionsReducer.Action>)
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
    
    @Dependency(\.authorizationControllerClient) var authorizationControllerClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onJoinButtonTap:
                    state.loginOptions = LoginOptionsReducer.State()
                    return .none
                    
                case .onDevelopedByTap:
                    state.developedBy = DevelopedByReducer.State()
                    return .none
                }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .authorizationResponse(.success(data)):
                    Log.info("authorizationResponse: \(data)")
                    return .none
                    
                case let .authorizationResponse(.failure(error)):
                    Log.error("authorizationResponse: \(error)")
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
                
            case let .loginOptions(.presented(.delegate(loginOptionsAction))):
                switch loginOptionsAction {
                case .didEmailLoginButtonSelected:
                    state.path.append(.emailLogin(.init()))
                    return .none
                    
                case .didAppleLoginButtonSelected:
                    Log.debug("didAppleLoginButtonSelected")
                    
//                    let provider = ASAuthorizationAppleIDProvider()
//                    let request = provider.createRequest()
//                    request.requestedScopes = [.fullName, .email]
//
//                    let controller = ASAuthorizationController(authorizationRequests: [request])
//                    controller.delegate = appleIDLoginClient.authorizationDelegate as? ASAuthorizationControllerDelegate
//                    controller.performRequests()
                    
                    return .run { send in
                        try await self.authorizationControllerClient.signIn()
                    }
                    
                case .didPhoneLoginButtonSelected:
                    state.path.append(.phoneLogin(.init()))
                    return .none
                }
                
            case .loginOptions(.dismiss):
                return .none                
                
            // #dev Here we will try to implement analytics client. A.P.
            case let .developedBy(.presented(.delegate(developedByAction))):
                switch developedByAction {
                case .didDevelopedByViewed:
                    return .none
                }
                            
            case .developedBy, .loginOptions, .delegate:
                return .none
            }
        }
        .ifLet(\.$developedBy, action: /Action.developedBy) { DevelopedByReducer() }
        .ifLet(\.$loginOptions, action: /Action.loginOptions) { LoginOptionsReducer() }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
