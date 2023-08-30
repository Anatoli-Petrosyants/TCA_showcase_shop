//
//  AuthenticationClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 21.06.23.
//

import Foundation
import Dependencies
import Get

/// A structure representing the login request parameters.
struct LoginRequest: Encodable {
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

/// A structure representing the authentication response.
struct AuthenticationResponse: Equatable, Decodable {
    var token: String
}

/// An enumeration representing possible authentication errors.
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

/// A client for handling authentication operations.
struct AuthenticationClient {
    /// A method for performing login using the provided credentials.
    var login: @Sendable (LoginRequest) async throws -> AuthenticationResponse
}

extension DependencyValues {
    /// Accessor for the AuthenticationClient in the dependency values.
    var authenticationClient: AuthenticationClient {
        get { self[AuthenticationClient.self] }
        set { self[AuthenticationClient.self] = newValue }
    }
}

extension AuthenticationClient: DependencyKey {
    /// A live implementation of AuthenticationClient.
    static let liveValue: Self = {
        return Self(
            login: { data in
                try await Task.sleep(nanoseconds: NSEC_PER_SEC)
                                
//                // Validate email
//                guard data.email.isValidEmail()
//                else { throw AuthenticationError.invalidEmail }
//
//                // Validate password
//                guard data.password.isValidPassword()
//                else { throw AuthenticationError.invalidUserPassword }

                // Construct parameters and perform API request
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

