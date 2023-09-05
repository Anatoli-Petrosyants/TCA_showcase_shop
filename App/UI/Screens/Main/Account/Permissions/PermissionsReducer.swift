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
            case onRequestNotificationsPermissionTap
            case binding(BindingAction<State>)
        }
        
        enum InternalAction: Equatable {
            case notificationsAuthorizationStatusResponse(TaskResult<UNAuthorizationStatus>)
            case requestNotificationsPermission
        }

        case view(ViewAction)
        case `internal`(InternalAction)
    }
    
    @Dependency(\.userNotificationClient.authorizationStatus) var authorizationStatus
    @Dependency(\.userNotificationClient.requestAuthorization) var requestAuthorization
    @Dependency(\.remoteNotificationsClient.register) var registerForRemoteNotifications
    
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
                                        await self.authorizationStatus()
                                    }
                                )
                            )
                        )
                    }
                    
                case .onRequestNotificationsPermissionTap:
                    return .send(.internal(.requestNotificationsPermission))
                    
                case .binding:
                    return .none
                }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case .requestNotificationsPermission:
                    Log.debug("requestNotificationsPermission")
                    return .run { _ in
                        _ = try await self.requestAuthorization([.alert, .sound])
                        await self.registerForRemoteNotifications()
                    }
                    
                case let .notificationsAuthorizationStatusResponse(.success(status)):
                    Log.debug("authorizationStatus success: \(status)")
                    return .run { _ in
                        switch status {
                        case .authorized:
                            Log.debug("authorizationStatus authorized")
                            guard try await self.requestAuthorization([.alert, .sound]) else {
                                return
                            }

                        case .notDetermined, .provisional:
                            Log.debug("authorizationStatus notDetermined, .provisional")
                            guard try await self.requestAuthorization(.provisional) else {
                                return
                            }

                        default:
                            Log.debug("authorizationStatus default: \(status)")
                            return
                        }
                        
                        Log.debug("registerForRemoteNotifications")
                        await self.registerForRemoteNotifications()
                    }
                    
                    
                    
                    
//                    switch status {
//                    case .authorized:
//                        Log.debug("authorizationStatus authorized")
//                        return .none
//
//                    case .notDetermined, .provisional:
//                        Log.debug("authorizationStatus notDetermined, .provisional")
//                        return .none
//
//                    default:
//                        Log.debug("authorizationStatus default: \(status)")
//                        return .none
//                    }
                    
                    
                    
//                    switch status {
//                    case .authorized:
//                        guard try await self.requestAuthorization([.alert, .sound]) else {
//                            return .none
//                        }
//
//                    case .notDetermined, .provisional:
//                        guard try await self.requestAuthorization(.provisional) else {
//                            return .none
//                        }
//
//                    default:
//                        return .none
//                    }
//
//                    return .run { _ in
//                        await self.registerForRemoteNotifications()
//                    }
                    
                case let .notificationsAuthorizationStatusResponse(.failure(error)):
                    Log.error("authorizationStatus failure: \(error.localizedDescription)")
                    return .none
                }

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
