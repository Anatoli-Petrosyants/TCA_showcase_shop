//
//  AuthenticationClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 21.06.23.
//

import Foundation
import Dependencies
import Get

struct LoginRequest: Encodable {
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

struct AuthenticationResponse: Equatable, Decodable {
    var token: String
}

enum AuthenticationError: Equatable, LocalizedError, Sendable {
    case invalidEmail
    case invalidUserPassword

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "User invalid email."
        case .invalidUserPassword:
            return "Unknown user or invalid password."
        }
    }
}

struct AuthenticationClient {
    var login: @Sendable (LoginRequest) async throws -> AuthenticationResponse
}

extension DependencyValues {
    var authenticationClient: AuthenticationClient {
        get { self[AuthenticationClient.self] }
        set { self[AuthenticationClient.self] = newValue }
    }
}

extension AuthenticationClient: DependencyKey {
    static let liveValue: Self = {
        return Self(
            login: { data in
                try await Task.sleep(nanoseconds: NSEC_PER_SEC)
                                
//                guard data.email.isValidEmail()
//                else { throw AuthenticationError.invalidEmail }
//
//                guard data.password.isValidPassword()
//                else { throw AuthenticationError.invalidUserPassword }

                let parameters = ["username" : data.email, "password" : data.password]
                var request = Request(path: "/auth/login",
                                      method: .post,
                                      body: parameters)
                    .withResponse(AuthenticationResponse.self)
                return try await apiClient.send(request).value
            }
        )
    }()
}
