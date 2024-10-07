//
//  AppFeature.swift
//  AppFeature
//
//  Created by Anatoli Petrosyants on 10.04.23.
//

import ComposableArchitecture
import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

@Reducer
struct AppFeature {

    @ObservableState
    enum State {
        case loading(LoadingFeature.State)
        case onboarding(OnboardingFeature.State)
        case join(JoinFeature.State)
        case main(MainFeature.State)

        public init() { self = .loading(LoadingFeature.State()) }
    }

    enum Action {
        enum AppDelegateAction: Equatable {
            case didFinishLaunching
            case didRegisterForRemoteNotifications(TaskResult<Data>)
            case userNotifications(UserNotificationClient.DelegateEvent)
            case didLaunchedWithShortcutItem(UIApplicationShortcutItem)
        }
        
        case appDelegate(AppDelegateAction)
        case didChangeScenePhase(ScenePhase)
        
        case loading(LoadingFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case join(JoinFeature.Action)
        case main(MainFeature.Action)
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.userKeychainClient) var userKeychainClient
    @Dependency(\.googleSignInClient) var googleSignInClient
    @Dependency(\.userNotificationClient) var userNotificationClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .appDelegate(appDelegateAction):
                switch appDelegateAction {
                case .didFinishLaunching:
                    // Configure Logger
                    Log.initialize()
                    
                    // Configure Firebase
                    FirebaseApp.configure()
                    
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        Log.debug("GIDSignIn user \(String(describing: user?.profile?.email))")
                        Log.debug("GIDSignIn error \(String(describing: error?.localizedDescription))")
                    }
                    
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
                    Log.info("userNotifications willPresentNotification notification: \(notification.request.content.userInfo)")
                    if let push = try? Push(decoding: notification.request.content.userInfo) {
                        Log.info("userNotifications willPresentNotification push: \(push)")
                    }
                    
                    return .run { send in
                        completionHandler(.banner)
                        
                        let notification = Notification(title: "Test", description: "Description", type: .checkout)
                        await send(.main(.addNotifications(notification)))
                    }
                    
                case let .userNotifications(.didReceiveResponse(response, completionHandler)):
                    Log.info("userNotifications didReceiveResponse response: \(response.request.content.userInfo))")
                    return .run { send in
                        completionHandler()
                        
                        if let push = try? Push(decoding: response.request.content.userInfo) {
                            Log.info("userNotifications didReceiveResponse push: \(push.aps.navigateTo!)")
                            await send(.main(.onTabChanged(.notifications)))
                        }
                    }

                case .userNotifications:
                    return .none
                    
                case let .didLaunchedWithShortcutItem(shortcutItem):
                    Log.info("didLaunchedWithShortcutItem: \(shortcutItem.type)")
                    
                    let action = QuickAction(shortcutItem: shortcutItem)
                    switch action {
                    case .favourites:
                        state = .main(MainFeature.State(currentTab: .wishlist))
                    case .basket:
                        state = .main(MainFeature.State(currentTab: .basket))
                    default:
                        break
                    }

                    return .none
                }
                
            case let .didChangeScenePhase(phase):
                Log.info("didChangeScenePhase \(phase)")
                return .none

            case let .loading(action: .delegate(loadingAction)):
                switch loadingAction {
                case .didLoaded:
                    if self.userDefaultsClient.hasShownFirstLaunchOnboarding {
                        if (self.userKeychainClient.retrieveToken() != nil) {
                            state = .main(MainFeature.State())
                        } else {
                            state = .join(JoinFeature.State())
                        }
                    } else {
                        state = .onboarding(OnboardingFeature.State())
                    }
                    return .none
                }
                
            case let .onboarding(action: .delegate(onboardingAction)):
                switch onboardingAction {
                case .didOnboardingFinished:
                    state = .join(JoinFeature.State())
                    return .none
                }

            case let .join(action: .delegate(joinAction)):
                switch joinAction {
                case .didAuthenticated:
                    state = .main(MainFeature.State())
                    return .none
                }
                
            case let .main(action: .delegate(mainAction)):
                switch mainAction {
                case .didLogout:
                    self.googleSignInClient.logout()
                    self.userKeychainClient.removeToken()
                    state = .loading(LoadingFeature.State())
                    return .none
                }
                
            case .loading, .onboarding, .join, .main:
                return .none
            }
        }
        .ifCaseLet(/State.loading, action: /Action.loading) {
            LoadingFeature()
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
            OnboardingFeature()
        }
        .ifCaseLet(/State.join, action: /Action.join) {
            JoinFeature()
        }
        .ifCaseLet(/State.main, action: /Action.main) {
            MainFeature()
        }
    }
}
