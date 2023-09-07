//
//  AppReducer.swift
//  AppReducer
//
//  Created by Anatoli Petrosyants on 10.04.23.
//

import ComposableArchitecture
import SwiftUI
import Foundation

struct AppReducer: Reducer {

    enum State: Equatable {
        case loading(LoadingReducer.State)
        case help(HelpReducer.State)
        case join(JoinReducer.State)
        case main(MainReducer.State)

        public init() { self = .loading(LoadingReducer.State()) }
    }

    enum Action: Equatable {
        enum AppDelegateAction: Equatable {
            case didFinishLaunching
            case didRegisterForRemoteNotifications(TaskResult<Data>)
            case userNotifications(UserNotificationClient.DelegateEvent)
        }
        
        case appDelegate(AppDelegateAction)
        case didChangeScenePhase(ScenePhase)
        case loading(LoadingReducer.Action)
        case help(HelpReducer.Action)
        case join(JoinReducer.Action)
        case main(MainReducer.Action)
    }
    
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.userKeychainClient) var userKeychainClient
    @Dependency(\.userNotificationClient) var userNotificationClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
    
            case let .appDelegate(appDelegateAction):
                switch appDelegateAction {
                case .didFinishLaunching:
                    Log.initialize()
                    
                    let userNotificationsEventStream = self.userNotificationClient.delegate()
                    return .run { send in
                        await withThrowingTaskGroup(of: Void.self) { group in
                            group.addTask {
                                for await event in userNotificationsEventStream {
                                    await send(.appDelegate(.userNotifications(event)))
                                }
                            }
                        }
                    }
                    
                case let .didRegisterForRemoteNotifications(.failure(error)):
                    Log.error("didRegisterForRemoteNotifications failure: \(error)")
                    return .none

                case let .didRegisterForRemoteNotifications(.success(tokenData)):
                    let token = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
                    Log.info("didRegisterForRemoteNotifications token: \(token)")
                    return .none
                    
                    
                case let .userNotifications(.willPresentNotification(notification, completionHandler)):
                    Log.debug("userNotifications willPresentNotification notification: \(notification.request.content.userInfo)")
                    if let push = try? Push(decoding: notification.request.content.userInfo) {
                        Log.debug("userNotifications willPresentNotification push: \(push)")
                    }
                    
                    return .run { _ in
                        completionHandler(.banner)
                    }
                    
                case let .userNotifications(.didReceiveResponse(response, completionHandler)):
                    Log.debug("userNotifications didReceiveResponse response: \(response.request.content.userInfo))")
                    if let push = try? Push(decoding: response.request.content.userInfo) {
                        Log.debug("userNotifications didReceiveResponse push: \(push.aps.navigateTo!)")
                    }
                    return .run { _ in
                        completionHandler()
                    }

                case .userNotifications:
                    return .none
                }
                
            case .didChangeScenePhase(_):                
                return .none

            case let .loading(action: .delegate(loadingAction)):
                switch loadingAction {
                case .onLoaded:
                    if self.userDefaults.hasShownFirstLaunchOnboarding {
                        if (self.userKeychainClient.retrieveToken() != nil) {
                            state = .main(MainReducer.State())
                        } else {
                            state = .join(JoinReducer.State())
                        }
                    } else {
                        state = .help(HelpReducer.State())
                    }
                    return .none
                }
                
            case let .help(action: .delegate(helpAction)):
                switch helpAction {
                case .didOnboardingFinished:
                    state = .join(JoinReducer.State())
                    return .none
                }

            case let .join(action: .delegate(joinAction)):
                switch joinAction {
                case .didAuthenticated:
                    Log.debug("didAuthenticated")
                    state = .main(MainReducer.State())
                    return .none
                }
                
            case let .main(action: .delegate(mainAction)):
                switch mainAction {
                case .didLogout:
                    state = .loading(LoadingReducer.State())
                    return .none
                }
                
            case .loading, .help, .join, .main:
                return .none
            }
        }
        .ifCaseLet(/State.loading, action: /Action.loading) {
            LoadingReducer()
        }
        .ifCaseLet(/State.help, action: /Action.help) {
            HelpReducer()
        }
        .ifCaseLet(/State.join, action: /Action.join) {
            JoinReducer()
        }
        .ifCaseLet(/State.main, action: /Action.main) {
            MainReducer()
        }
    }
}
