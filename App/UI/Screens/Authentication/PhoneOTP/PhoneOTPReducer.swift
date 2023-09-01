//
//  PhoneOTPReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.08.23.
//

import SwiftUI
import ComposableArchitecture

struct PhoneOTPReducer: Reducer {
    
    struct State: Equatable, Hashable {
        
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onResendButtonTap
            case onCodeChanged(String)
        }

        enum Delegate {
            case didCodeAuthenticated
        }

        case view(ViewAction)
        case delegate(Delegate)
    }
    
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(.onCodeChanged(code)):
                Log.debug("onCodeChanged code \(code)")
                return .none
                
            case .view(.onResendButtonTap):
                // return .send(.delegate(.didCodeAuthenticated))
                // state.isActivityIndicatorVisible = false
                Log.debug("onResendButtonTap")                
                return .concatenate(
                    .run { _ in
                        await self.userDefaults.setToken("otp_token")

                        let account = Account(token: "otp_token")
                        try await self.databaseClient.insert(account)
                    },
                    .send(.delegate(.didCodeAuthenticated))
                )
                
            case .delegate:
                return .none
            }
        }
    }
}

//import SwiftUI
//import ComposableArchitecture
//
//struct PhoneOTPReducer: Reducer {
//
//    struct State: Equatable {
//        var isActivityIndicatorVisible = false
//    }
//
//    enum Action: Equatable {
//        enum ViewAction: Equatable {
//            case onResendButtonTap
//            case onCodeChanged(String)
//        }
//
//        enum Delegate {
//            case didCodeAuthenticated
//        }
//
//        case view(ViewAction)
//        case delegate(Delegate)
//    }
//
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case let .view(viewAction):
//                switch viewAction {
//                case let .onCodeChanged(code):
//                    Log.debug("onCodeChanged \(code)")
//                    return .none
////                    return (code == Constant.validPhoneCode)
////                    ? .send(.delegate(.didCodeAuthenticated))
////                    : .none
//
//                case .onResendButtonTap:
//                    Log.debug("onResendButtonTap")
//                    state.isActivityIndicatorVisible = true
//                    return .none
//                }
//
//            case .delegate:
//                return .none
//            }
//        }
//    }
//}
