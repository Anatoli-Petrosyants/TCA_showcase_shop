//
//  RemoteNotificationsClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.09.23.
//

import Foundation
import Dependencies
import UIKit

struct RemoteNotificationsClient {
    var isRegistered: @Sendable () async -> Bool
    var register: @Sendable () async -> Void
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
    static let liveValue = Self(
        isRegistered: { await UIApplication.shared.isRegisteredForRemoteNotifications },
        register: { await UIApplication.shared.registerForRemoteNotifications() },
        unregister: { await UIApplication.shared.unregisterForRemoteNotifications() }
    )
}

