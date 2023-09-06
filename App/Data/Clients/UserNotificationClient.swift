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

struct APS: Codable {
    let alert: APSAlert?
    let badge: Int?
    let sound: String?
    let navigateTo: String?
}

struct APSAlert: Codable {
    let title: String?
    let subtitle: String?
    let body: String?
}

struct PushNotification: Decodable {
    let aps: APS
}

extension UNNotification {
    
    func pushNotification() -> PushNotification? {
        let userInfo = request.content.userInfo
        let decoder = DictionaryDecoder()
        return try? decoder.decode(PushNotification.self, from: userInfo)
    }
}

/// A client for managing user notifications including authorization, status, and delegate events.
struct UserNotificationClient {
    /// Requests authorization for specific notification options.
    var requestAuthorization: @Sendable (UNAuthorizationOptions) async throws -> Bool
    
    /// Retrieves the authorization status for notifications.
    var authorizationStatus: @Sendable () async -> UNAuthorizationStatus
    
    /// Adds a notification request.
    var add: @Sendable (UNNotificationRequest) async throws -> Void
    
    /// Removes delivered notifications with specified identifiers.
    var removeDeliveredNotificationsWithIdentifiers: @Sendable ([String]) async -> Void
    
    /// Removes pending notification requests with specified identifiers.
    var removePendingNotificationRequestsWithIdentifiers: @Sendable ([String]) async -> Void
    
    /// Provides an asynchronous stream of delegate events for user notifications.
    var delegate: @Sendable () -> AsyncStream<DelegateEvent>
    
    /// Delegate events for user notifications.
    enum DelegateEvent: Equatable {
        case didReceiveResponse(Notification.Response, completionHandler: @Sendable () -> Void)
        case openSettingsForNotification(Notification?)
        case willPresentNotification(Notification, completionHandler: @Sendable (UNNotificationPresentationOptions) -> Void)

        static func == (lhs: Self, rhs: Self) -> Bool {
            // Equatable implementation for DelegateEvent
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

    /// Represents a user notification with date and request information.
    struct Notification: Equatable {
        var date: Date
        var request: UNNotificationRequest

        init(date: Date, request: UNNotificationRequest) {
            self.date = date
            self.request = request
        }

        /// Represents a response to a user notification.
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
        add: {
            try await UNUserNotificationCenter.current().add($0)
        },
        removeDeliveredNotificationsWithIdentifiers: {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: $0)
        },
        removePendingNotificationRequestsWithIdentifiers: {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: $0)
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
    /// Initializes a `UserNotificationClient.Notification` instance from a raw UNNotification.
    ///
    /// - Parameter rawValue: The raw UNNotification instance to convert.
    init(rawValue: UNNotification) {
        self.date = rawValue.date
        self.request = rawValue.request
    }
}

extension UserNotificationClient.Notification.Response {
    /// Initializes a `UserNotificationClient.Notification.Response` instance from a raw UNNotificationResponse.
    ///
    /// - Parameter rawValue: The raw UNNotificationResponse instance to convert.
    init(rawValue: UNNotificationResponse) {
        self.notification = .init(rawValue: rawValue.notification)
    }
}

extension UserNotificationClient {
    /// A private class that acts as the delegate for user notification events.
    fileprivate class Delegate: NSObject, UNUserNotificationCenterDelegate {
        let continuation: AsyncStream<UserNotificationClient.DelegateEvent>.Continuation

        /// Initializes the delegate with an asynchronous stream continuation.
        init(continuation: AsyncStream<UserNotificationClient.DelegateEvent>.Continuation) {
            self.continuation = continuation
        }

        /// Called when a user notification response is received.
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
        ) {
            // Yield a `didReceiveResponse` event with the response and its completion handler.
            self.continuation.yield(.didReceiveResponse(.init(rawValue: response)) { completionHandler() })
        }

        /// Called when the user opens settings for a notification.
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            openSettingsFor notification: UNNotification?
        ) {
            // Yield an `openSettingsForNotification` event with the notification (if available).
            self.continuation.yield(.openSettingsForNotification(notification.map(Notification.init(rawValue:))))
        }

        /// Called when a notification is about to be presented.
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            // Yield a `willPresentNotification` event with the notification and its presentation options completion handler.
            self.continuation.yield(.willPresentNotification(.init(rawValue: notification)) { completionHandler($0) })
        }
    }
}

// Test push on iPhone 14 Pro Max
// xcrun simctl push CD54D208-0E7F-4C30-8DD9-69020F239CC5 ap.Showcase test_push_notification.apns
