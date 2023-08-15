//
//  UsersClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.06.23.
//

import Foundation
import Dependencies
import Get

struct UsersClient {
    var users: @Sendable () async throws -> [User]
}

extension DependencyValues {
    var usersClient: UsersClient {
        get { self[UsersClient.self] }
        set { self[UsersClient.self] = newValue }
    }
}

extension UsersClient: DependencyKey {
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
