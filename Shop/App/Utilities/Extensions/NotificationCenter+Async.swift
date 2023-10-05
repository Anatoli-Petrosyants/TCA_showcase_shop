//
//  NotificationCenter+Async.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.07.23.
//

import Foundation

public extension NotificationCenter {
    @discardableResult
    func observeNotifications(
        from notification: Foundation.Notification.Name
    ) -> AsyncStream<Any?> {
        AsyncStream { continuation in
            let reference = NotificationCenter.default.addObserver(
                forName: notification,
                object: nil,
                queue: nil
            ) { notif in
                continuation.yield(notif.object)
            }

            continuation.onTermination = { @Sendable _ in
                NotificationCenter.default.removeObserver(reference)
            }
        }
    }
}
