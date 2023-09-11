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
        var title = ""
        var message = ""
        var buttonTitle = ""
        var authorizationStatus: UNAuthorizationStatus = .notDetermined
    }
    
    enum Action: Equatable {
        enum ViewAction:  BindableAction, Equatable {
            case onViewAppear
            case onRequestNotificationsPermissionTap
            case binding(BindingAction<State>)
        }
        
        enum InternalAction: Equatable {
            case contactsAuthorizationStatusResult(TaskResult<UNAuthorizationStatus>)
            case requestNotificationsPermission
        }

        case view(ViewAction)
        case `internal`(InternalAction)
    }
    
    @Dependency(\.userNotificationClient.authorizationStatus) var authorizationStatus
    @Dependency(\.userNotificationClient.requestAuthorization) var requestAuthorization
    @Dependency(\.remoteNotificationsClient.register) var registerForRemoteNotifications
    @Dependency(\.applicationClient.open) var openURL
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: /Action.view)
        
        Reduce { state, action in
            switch action {
                // view actions
                case let .view(viewAction):
                switch viewAction {
                case .onViewAppear:
                    return .run { send in
                        await send(
                            .internal(
                                .contactsAuthorizationStatusResult(
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
                    switch state.authorizationStatus {
                    case .notDetermined, .provisional:
                        return .run { _ in
                            do {
                                _ = try await self.requestAuthorization([.alert, .sound])
                                await self.registerForRemoteNotifications()
                                await self.dismiss()
                            } catch {
                                Log.error("requestNotificationsPermission error: \(error)")
                            }
                        }
                        
                    default:
                        return .concatenate(
                            .run { _ in
                                _ = await self.openURL(URL(string: UIApplication.openSettingsURLString)!, [:])
                            },
                            .run { _ in await self.dismiss() }
                        )
                    }

                case let .contactsAuthorizationStatusResult(.success(status)):
                    state.authorizationStatus = status
                    switch status {
                    case .authorized:
                        state.title = "Authorization status: Authorized"
                        state.message = "To change permissions, open settings."
                        state.buttonTitle = "Open Settings"
                        
                    case .notDetermined, .provisional:
                        state.title = "Authorization status: NotDetermined or Provisional"
                        state.message = "To change permissions, request permissions."
                        state.buttonTitle = "Request Permissions"
                        
                    case .denied:
                        state.title = "Authorization status Denied."
                        state.message = "To change permissions, open settings."
                        state.buttonTitle = "Open Settings"
                        
                    default:
                        state.message = "authorization status default: \(status)"
                    }
                    return .none
                    
                case let .contactsAuthorizationStatusResult(.failure(error)):
                    Log.error("authorizationStatus failure: \(error.localizedDescription)")
                    return .none
                }
            }
        }
    }
}
