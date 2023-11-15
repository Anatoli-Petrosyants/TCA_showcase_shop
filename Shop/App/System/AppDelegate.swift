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

/// The application delegate responsible for handling app-level events.
final class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The main store of the Composable Architecture.
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    /// The method called when the application finishes launching.
    ///
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any).
    /// - Returns: `true` if the app was launched successfully; otherwise, `false`.
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool { 
        // Configure Firebase
        FirebaseApp.configure()
        
//        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
//            print("shortcutItem")
//            self.store.send(.appDelegate(.didLaunchedWithShortcutItem(shortcutItem)))
//        }
        
        // Send an initial action to the store indicating that the app has finished launching
        self.store.send(.appDelegate(.didFinishLaunching))
        return true
    }
    
    /// The method called when the app successfully registers for remote notifications.
    ///
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - deviceToken: A token that identifies the device to APNs.
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        self.store.send(.appDelegate(.didRegisterForRemoteNotifications(.success(deviceToken))))
    }

    /// The method called when the app fails to register for remote notifications.
    ///
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - error: The error that occurred during registration.
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        self.store.send(.appDelegate(.didRegisterForRemoteNotifications(.failure(error))))
    }
    
    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        print("performActionFor")
        completionHandler(true)
    }
    
//    func application(_ application: UIApplication,
//                     performActionFor shortcutItem: UIApplicationShortcutItem,
//                     completionHandler: @escaping (Bool) -> Void) {
//        
//    }
    
//    /// The method called to provide a UISceneConfiguration.
//    ///
//    /// - Parameters:
//    ///   - application: The singleton app object.
//    ///   - connectingSceneSession: The new UISceneSession being created.
//    ///   - options: A dictionary of details about the launch environment.
//    /// - Returns: The newly created scene configuration.
//    func application(
//        _ application: UIApplication,
//        configurationForConnecting connectingSceneSession: UISceneSession,
//        options: UIScene.ConnectionOptions
//    ) -> UISceneConfiguration {
//        // Create and configure the scene configuration
//        let configuration = UISceneConfiguration(
//            name: connectingSceneSession.configuration.name,
//            sessionRole: connectingSceneSession.role
//        )
//        
//        if connectingSceneSession.role == .windowApplication {
//            configuration.delegateClass = SceneDelegate.self
//        }        
//        return configuration
//    }
}
