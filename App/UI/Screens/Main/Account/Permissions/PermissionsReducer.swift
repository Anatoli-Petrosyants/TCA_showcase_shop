//
//  PermissionsReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.09.23.
//

import SwiftUI
import ComposableArchitecture
import UserNotifications

struct PermissionsReducer: Reducer {
    
    struct State: Equatable, Hashable {
        
    }
    
    enum Action: Equatable {
        enum ViewAction:  BindableAction, Equatable {
            case onViewAppear
            case onNotificationsTap
            case binding(BindingAction<State>)
        }
        
        enum InternalAction: Equatable {
            case notificationsAuthorizationStatusResponse(TaskResult<UNAuthorizationStatus>)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
    }
    
    @Dependency(\.userNotificationClient) var userNotificationClient
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: /Action.view)
        
        Reduce { state, action in
            switch action {
                // view actions
                case let .view(viewAction):
                switch viewAction {
                case .onViewAppear:
                    return .none
                    
                case .onNotificationsTap:
                    return .run { send in
                        await send(
                            .internal(
                                .notificationsAuthorizationStatusResponse(
                                    await TaskResult {
                                        await self.userNotificationClient.authorizationStatus()
                                    }
                                )
                            )
                        )
                    }
                    
                case .binding:
                    return .none
                }
                
            // internal actions
            case let .internal(internalAction):
                return .none
                
//                switch internalAction {
//                case let .notificationsAuthorizationStatusResponse(.success(data)):
//                    Log.debug("authorizationStatus success: \(data)")
//
//                    switch data {
//                    case .notDetermined, .provisional:
//                        Log.debug("authorizationStatus notDetermined, .provisional")
//                        return .run { _ in
//                            try await self.userNotificationClient.requestAuthorization(.provisional)
//                        }
//
//                    case .authorized:
//                        Log.debug("authorizationStatus authorized")
//                        return .run { _ in
//                            try await self.userNotificationClient.requestAuthorization([.alert, .sound])
//                        }
//
//                    case .denied:
//                        Log.debug("authorizationStatus denied")
//                        return .none
//
//                    default:
//                        return .none
//                    }
//
////                    switch data {
////                    case .notDetermined, .provisional:
////                        Log.debug("authorizationStatus notDetermined")
////
////                    case .authorized:
////                        Log.debug("authorizationStatus authorized")
////
////                    case .authorized:
////
////                    }
//
//                    return .none
//
//                case let .notificationsAuthorizationStatusResponse(.failure(error)):
//                    Log.error("authorizationStatus failure: \(error.localizedDescription)")
//                    return .none
//                }
            }
        }
    }
}
