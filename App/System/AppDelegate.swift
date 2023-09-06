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
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        self.store.send(.appDelegate(.didRegisterForRemoteNotifications(.success(deviceToken))))
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        self.store.send(.appDelegate(.didRegisterForRemoteNotifications(.failure(error))))
    }
}

//// MARK: - UNUserNotificationCenterDelegate
//func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//    PushNotificationManager.shared.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
//    ChatAnalytics.shared.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
//}
//
//func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    PushNotificationManager.shared.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
//}
