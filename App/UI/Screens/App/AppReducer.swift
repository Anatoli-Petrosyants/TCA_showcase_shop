//
//  AppReducer.swift
//  AppReducer
//
//  Created by Anatoli Petrosyants on 10.04.23.
//

import ComposableArchitecture
import SwiftUI

struct AppReducer: ReducerProtocol {

    enum State: Equatable {
        case loading(Loading.State)
        case help(Help.State)
        case login(LoginReducer.State)
        case main(MainReducer.State)

        public init() { self = .loading(Loading.State()) }
    }

    enum Action: Equatable {
        enum AppDelegateAction: Equatable {
            case didFinishLaunching
        }
        
        case appDelegate(AppDelegateAction)
        case didChangeScenePhase(ScenePhase)
        case loading(Loading.Action)
        case help(Help.Action)
        case login(LoginReducer.Action)
        case main(MainReducer.Action)
    }
    
    @Dependency(\.userDefaults) var userDefaults

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
    
            case let .appDelegate(appDelegateAction):
                switch appDelegateAction {
                case .didFinishLaunching:
                    Log.initialize()
                    return .none
                }
                
            case .didChangeScenePhase(_):                
                return .none

            case let .loading(action: .delegate(loadingAction)):
                switch loadingAction {
                case .onLoaded:
                    if self.userDefaults.hasShownFirstLaunchOnboarding {
                        if (self.userDefaults.token != nil) {
                            state = .main(MainReducer.State())
                        } else {
                            state = .login(LoginReducer.State())
                        }
                    } else {
                        state = .help(Help.State())
                    }
                    return .none
                }
                
            case let .help(action: .delegate(helpAction)):
                switch helpAction {
                case .didOnboardingFinished:
                    state = .login(LoginReducer.State())
                    return .none
                }
                
            case let .login(action: .delegate(loginAction)):
                switch loginAction {
                case .didAuthenticated:
                    state = .main(MainReducer.State())
                    return .none
                }
                
            case let .main(action: .delegate(mainAction)):
                switch mainAction {
                case .didLogout:
                    state = .loading(Loading.State())
                    return .none
                }
                
            case .loading, .help, .login, .main:
                return .none
            }
        }
        .ifCaseLet(/State.loading, action: /Action.loading) {
            Loading()
        }
        .ifCaseLet(/State.help, action: /Action.help) {
            Help()
        }
        .ifCaseLet(/State.login, action: /Action.login) {
            LoginReducer()
        }
        .ifCaseLet(/State.main, action: /Action.main) {
            MainReducer()
        }
    }
}
