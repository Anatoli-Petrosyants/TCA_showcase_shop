//
//  AppDelegate.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.02.23.
// 

import UIKit
import SwiftUI
import ComposableArchitecture
import FirebaseCore
import FirebaseFirestore

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let store = Store(initialState: AppReducer.State()) {
        AppReducer()
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {        
        FirebaseApp.configure()
        self.store.send(.appDelegate(.didFinishLaunching))
        return true
    }
}
