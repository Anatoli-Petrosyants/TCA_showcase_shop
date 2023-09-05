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
    var delegate: @Sendable () -> AsyncStream<DelegateEvent>
    
    enum DelegateEvent: Equatable {
        case didReceiveResponse(Notification.Response, completionHandler: @Sendable () -> Void)
        case openSettingsForNotification(Notification?)
        case willPresentNotification(Notification, completionHandler: @Sendable (UNNotificationPresentationOptions) -> Void)

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.didReceiveResponse(lhs, _), .didReceiveResponse(rhs, _)):
                return lhs == rhs
            case let (.openSettingsForNotification(lhs), .openSettingsForNotification(rhs)):
                return lhs == rhs
            case let (.willPresentNotification(lhs, _), .willPresentNotification(rhs, _)):
                return lhs == rhs
            default:
                return false
            }
        }
    }

    struct Notification: Equatable {
        var date: Date
        var request: UNNotificationRequest

        init(date: Date, request: UNNotificationRequest) {
            self.date = date
            self.request = request
        }

        struct Response: Equatable {
            var notification: Notification

            init(notification: Notification) {
                self.notification = notification
            }
        }
    }
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
        },
        delegate: {
            AsyncStream { continuation in
                let delegate = Delegate(continuation: continuation)
                UNUserNotificationCenter.current().delegate = delegate
                continuation.onTermination = { _ in
                    _ = delegate
                }
            }
        }
    )
}

extension UserNotificationClient.Notification {
    init(rawValue: UNNotification) {
        self.date = rawValue.date
        self.request = rawValue.request
    }
}

extension UserNotificationClient.Notification.Response {
    init(rawValue: UNNotificationResponse) {
        self.notification = .init(rawValue: rawValue.notification)
    }
}

extension UserNotificationClient {
    fileprivate class Delegate: NSObject, UNUserNotificationCenterDelegate {
        let continuation: AsyncStream<UserNotificationClient.DelegateEvent>.Continuation

        init(continuation: AsyncStream<UserNotificationClient.DelegateEvent>.Continuation) {
            self.continuation = continuation
        }

        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
        ) {
            self.continuation.yield(.didReceiveResponse(.init(rawValue: response)) { completionHandler() })
        }

        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            openSettingsFor notification: UNNotification?
        ) {
            self.continuation.yield(.openSettingsForNotification(notification.map(Notification.init(rawValue:))))
        }

        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            self.continuation.yield(.willPresentNotification(.init(rawValue: notification)) { completionHandler($0) })
        }
    }
}
