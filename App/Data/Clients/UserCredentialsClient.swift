//
//  UserCredentialsClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 07.09.23.
//

import Foundation
import Dependencies
import UIKit

struct UserCredentialsClient {
    
    /// Adds a notification request.
    var add: @Sendable (UNNotificationRequest) async throws -> Void
    
//    var accessToken: @Sendable () async -> String?
//    let storeAccessToken: (_ token: String) async throws -> Void
}

extension DependencyValues {
    /// Accessor for the RemoteNotificationsClient in the dependency values.
    var userCredentialsClient: UserCredentialsClient {
        get { self[UserCredentialsClient.self] }
        set { self[UserCredentialsClient.self] = newValue }
    }
}

extension UserCredentialsClient: DependencyKey {
    /// Provides a live implementation of RemoteNotificationsClient with appropriate functions.
    static let liveValue = Self(
        accessToken: {
            return await "aas"
        }
//        ,
//        storeAccessToken: {
//
//        }
    )
}
