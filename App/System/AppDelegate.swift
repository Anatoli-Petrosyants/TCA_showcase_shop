//
//  AppDelegate.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.02.23.
// 

import UIKit
import SwiftUI
import ComposableArchitecture

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let store = Store(initialState: AppReducer.State()) {
        AppReducer()
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        self.store.send(.appDelegate(.didFinishLaunching))
        return true
    }

//    let store = Store(
//        initialState: AppReducer.State(),
//        reducer: AppReducer()
//    )
//
//    var viewStore: ViewStore<Void, AppReducer.Action> {
//        ViewStore(self.store.stateless)
//    }
//
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
//    ) -> Bool {
//        self.viewStore.send(.appDelegate(.didFinishLaunching))
//        return true
//    }
}
