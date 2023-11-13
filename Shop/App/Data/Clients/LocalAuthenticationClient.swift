//
//  LocalAuthenticationClient.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 13.11.23.
//

import Foundation
import Dependencies
import LocalAuthentication

/// A client for handling Local Authentication.
struct LocalAuthenticationClient {
    /// An asynchronous function to authenticate using biometrics with reason.
    var authenticate: @Sendable (String) async throws -> Bool
}

/// Extension to provide access to LocalAuthenticationClient in the dependency values.
extension DependencyValues {
    var localAuthenticationClient: LocalAuthenticationClient {
        get { self[LocalAuthenticationClient.self] }
        set { self[LocalAuthenticationClient.self] = newValue }
    }
}

/// Extension to make LocalAuthenticationClient a DependencyKey.
extension LocalAuthenticationClient: DependencyKey {
    /// The live implementation of LocalAuthenticationClient.
    static let liveValue: Self = {
        // Create an instance of LAContext for handling biometric authentication.
        let context = LAContext()
        
        return Self(
            authenticate: { reason in
                // Use withCheckedThrowingContinuation for asynchronous authentication.
                return try await withCheckedThrowingContinuation { continuation in
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                           localizedReason: reason) { success, error in
                        if let err = error {
                            continuation.resume(with: .failure(err))
                        } else {
                            continuation.resume(returning: success)
                        }
                    }
                }
            }
        )
    }()
}
