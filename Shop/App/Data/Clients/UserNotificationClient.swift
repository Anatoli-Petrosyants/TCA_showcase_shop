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

// Test push on iPhone 14 Pro Max
// xcrun simctl push CD54D208-0E7F-4C30-8DD9-69020F239CC5 ap.Showcase test_push_notification.apns

/// Represents a push notification received from APNs (Apple Push Notification Service).
struct Push: Decodable {
    let aps: APS // The payload of the push notification.

    /// Represents the payload of the push notification.
    struct APS: Decodable {
        let alert: Alert         // The alert information to display.
        let badge: Int?          // The badge number to display.
        let sound: String?      // The name of the sound to play.
        let navigateTo: String? // The destination to navigate to in response to the notification.

        /// Represents the alert information to display in the push notification.
        struct Alert: Decodable {
            let title: String?    // The title of the notification.
            let subtitle: String? // The subtitle of the notification.
            let body: String?     // The main body text of the notification.
        }
    }

    /// Initializes a `Push` instance by decoding a dictionary of notification data.
    /// - Parameter userInfo: The dictionary containing notification data received from APNs.
    /// - Throws: An error if decoding the notification data fails.
    init(decoding userInfo: [AnyHashable : Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
        self = try JSONDecoder().decode(Push.self, from: data)
    }
}

/// Represents a push notification and its associated information.
struct PushNotification: Equatable {
    var date: Date              // The date when the push notification was received.
    var request: UNNotificationRequest // The UNNotificationRequest associated with the notification.

    /// Initializes a `PushNotification` with the given date and request.
    /// - Parameters:
    ///   - date: The date when the push notification was received.
    ///   - request: The UNNotificationRequest associated with the notification.
    init(date: Date, request: UNNotificationRequest) {
        self.date = date
        self.request = request
    }

    /// Represents a response to a push notification.
    struct Response: Equatable {
        var notification: PushNotification // The push notification associated with the response.

        /// Initializes a `Response` with the given push notification.
        /// - Parameter notification: The push notification associated with the response.
        init(notification: PushNotification) {
            self.notification = notification
        }
    }
}

extension PushNotification {
    /// Initializes a `PushNotification` instance from a raw UNNotification.
    ///
    /// - Parameter rawValue: The raw UNNotification instance to convert.
    init(rawValue: UNNotification) {
        self.date = rawValue.date
        self.request = rawValue.request
    }
}

extension PushNotification.Response {
    /// Initializes a `UserNotificationClient.Notification.Response` instance from a raw UNNotificationResponse.
    ///
    /// - Parameter rawValue: The raw UNNotificationResponse instance to convert.
    init(rawValue: UNNotificationResponse) {
        self.notification = .init(rawValue: rawValue.notification)
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
        case didReceiveResponse(PushNotification, completionHandler: @Sendable () -> Void)
        case willPresentNotification(PushNotification, completionHandler: @Sendable (UNNotificationPresentationOptions) -> Void)

        static func == (lhs: Self, rhs: Self) -> Bool {
            // Equatable implementation for DelegateEvent
            switch (lhs, rhs) {
            case let (.didReceiveResponse(lhs, _), .didReceiveResponse(rhs, _)):
                return lhs == rhs
            case let (.willPresentNotification(lhs, _), .willPresentNotification(rhs, _)):
                return lhs == rhs
            default:
                return false
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
            self.continuation.yield(
                .didReceiveResponse(.init(rawValue: response.notification)) {
                    DispatchQueue.main.async {
                        completionHandler()
                    }
                }
            )
        }

        /// Called when a notification is about to be presented.
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            // Yield a `willPresentNotification` event with the notification and its presentation options completion handler.
            self.continuation.yield(
                .willPresentNotification(.init(rawValue: notification)) { completionHandler($0) }
            )
        }
    }
}

extension UNAuthorizationStatus {

    var description: String {
        switch self {
        case .notDetermined:
            return "Not Determined"
        case .denied:
            return "Denied"
        case .authorized:
            return "Authorized"
        case .provisional:
            return "Provisional"
        default:
            return "Unknown"
        }
    }
}
