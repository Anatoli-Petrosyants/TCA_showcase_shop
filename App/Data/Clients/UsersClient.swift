//
//  UsersClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.06.23.
//

import Foundation
import Dependencies
import Get

/// A client for handling users-related operations.
struct UsersClient {
    /// A method for fetching all users.
    var users: @Sendable () async throws -> [User]
}

extension DependencyValues {
    /// Accessor for the UsersClient in the dependency values.
    var usersClient: UsersClient {
        get { self[UsersClient.self] }
        set { self[UsersClient.self] = newValue }
    }
}

extension UsersClient: DependencyKey {
    /// A live implementation of UsersClient.
    static let liveValue: Self = {
        return Self(
            users: {
                var request = Request(path: "/users",
                                      method: .get)
                    .withResponse([UserDTO].self)
                return try await apiClient.send(request).value.compactMap { $0.toEntity() }
            }
        )
    }()
}
