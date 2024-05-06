//
//  PhoneOTPFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.08.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct PhoneOTPFeature {
    
    @ObservableState
    struct State: Equatable, Hashable {
        var code = ""
        var isActivityIndicatorVisible = false
    }
    
    enum Action: Equatable, BindableAction {
        enum ViewAction: Equatable {
            case onResendButtonTap
        }
        
        enum InternalAction: Equatable {
            case codeResponse
        }

        enum Delegate {
            case didCodeAuthenticated
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.userKeychainClient) var userKeychainClient
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .view(.onResendButtonTap):
                return .none
                
            case .internal(.codeResponse):
                guard state.code == Constant.validPhoneCode else { return .none }
                state.isActivityIndicatorVisible = true
                userKeychainClient.storeToken("otp_token")
                return .concatenate(
                    .run { _ in
                        try await self.clock.sleep(for: .seconds(2))
                        let account = Account(token: "otp_token")
                        try await self.databaseClient.insert(account)
                    },
                    .send(.delegate(.didCodeAuthenticated))
                )
                
            case .binding(\.code):
                return .send(.internal(.codeResponse))
                
            case .binding:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
