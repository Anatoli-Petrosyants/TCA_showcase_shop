//
//  UserNotificationClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.09.23.
//

import Foundation
import UIKit
import Dependencies
import UserNotifications

struct UserNotificationClient {
    var requestAuthorization: @Sendable (UNAuthorizationOptions) async throws -> Bool
    var authorizationStatus: @Sendable () async -> UNAuthorizationStatus
}

extension DependencyValues {
    /// Accessor for the UserNotificationClient in the dependency values.
    var userNotificationClient: UserNotificationClient {
        get { self[UserNotificationClient.self] }
        set { self[UserNotificationClient.self] = newValue }
    }
}

extension UserNotificationClient: DependencyKey {
    /// A live implementation of UserNotificationClient.
    static let liveValue = Self(
        requestAuthorization: {
            try await UNUserNotificationCenter.current().requestAuthorization(options: $0)
        },
        authorizationStatus: {
            await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        }
    )
}
