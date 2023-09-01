//
//  AppReducer.swift
//  AppReducer
//
//  Created by Anatoli Petrosyants on 10.04.23.
//

import ComposableArchitecture
import SwiftUI

struct AppReducer: Reducer {

    enum State: Equatable {
        case loading(LoadingReducer.State)
        case help(HelpReducer.State)
        case loginOptions(LoginOptionsReducer.State)
        case main(MainReducer.State)

        public init() { self = .loading(LoadingReducer.State()) }
    }

    enum Action: Equatable {
        enum AppDelegateAction: Equatable {
            case didFinishLaunching
        }
        
        case appDelegate(AppDelegateAction)
        case didChangeScenePhase(ScenePhase)
        case loading(LoadingReducer.Action)
        case help(HelpReducer.Action)
        case loginOptions(LoginOptionsReducer.Action)
        case main(MainReducer.Action)
    }
    
    @Dependency(\.userDefaults) var userDefaults

    var body: some Reducer<State, Action> {
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
                            state = .loginOptions(LoginOptionsReducer.State())
                        }
                    } else {
                        state = .help(HelpReducer.State())
                    }
                    return .none
                }
                
            case let .help(action: .delegate(helpAction)):
                switch helpAction {
                case .didOnboardingFinished:
                    state = .loginOptions(LoginOptionsReducer.State())
                    return .none
                }

            case let .loginOptions(action: .delegate(loginOptionsAction)):
                switch loginOptionsAction {
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
                
            case .loading, .help, .loginOptions, .main:
                return .none
            }
        }
        .ifCaseLet(/State.loading, action: /Action.loading) {
            LoadingReducer()
        }
        .ifCaseLet(/State.help, action: /Action.help) {
            HelpReducer()
        }
        .ifCaseLet(/State.loginOptions, action: /Action.loginOptions) {
            LoginOptionsReducer()
        }
        .ifCaseLet(/State.main, action: /Action.main) {
            MainReducer()
        }
    }
}
