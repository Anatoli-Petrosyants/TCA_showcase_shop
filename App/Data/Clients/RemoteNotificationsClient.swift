//
//  RemoteNotificationsClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.09.23.
//

import Foundation
import Dependencies
import UIKit

/// A client for handling remote notifications, including registration and unregistration.
struct RemoteNotificationsClient {
    /// Checks if the app is registered for remote notifications.
    var isRegistered: @Sendable () async -> Bool
    
    /// Registers the app for remote notifications.
    var register: @Sendable () async -> Void
    
    /// Unregisters the app from receiving remote notifications.
    var unregister: @Sendable () async -> Void
}

extension DependencyValues {
    /// Accessor for the RemoteNotificationsClient in the dependency values.
    var remoteNotificationsClient: RemoteNotificationsClient {
        get { self[RemoteNotificationsClient.self] }
        set { self[RemoteNotificationsClient.self] = newValue }
    }
}

extension RemoteNotificationsClient: DependencyKey {
    /// Provides a live implementation of RemoteNotificationsClient with appropriate functions.
    static let liveValue = Self(
        isRegistered: { await UIApplication.shared.isRegisteredForRemoteNotifications },
        register: { await UIApplication.shared.registerForRemoteNotifications() },
        unregister: { await UIApplication.shared.unregisterForRemoteNotifications() }
    )
}


