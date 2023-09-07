//
//  UserCredentialsClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 07.09.23.
//

import Foundation
import Dependencies
import UIKit
import SwiftKeychainWrapper

// #dev Here, I am currently storing only the OAuth token,
// but in the future, we can consider adding the OAuth object. A.P.

struct UserKeychainClient {
    /// A function to store or update user credentials in the Keychain.
    var storeToken: @Sendable (String) -> Void

    /// A function to retrieve user credentials from the Keychain.
    var retrieveToken: @Sendable () -> String?

    /// A function to remove user credentials from the Keychain.
    var removeToken: @Sendable () -> Void
}

extension DependencyValues {
    /// Accessor for the UserCredentialsClient in the dependency values.
    var userKeychainClient: UserKeychainClient {
        get { self[UserKeychainClient.self] }
        set { self[UserKeychainClient.self] = newValue }
    }
}

extension UserKeychainClient: DependencyKey {
    /// A live implementation of UserCredentialsClient.
    static let liveValue: UserKeychainClient = {
        // Initialize KeychainWrapper with the service name
        let keychainWrapper = KeychainWrapper(serviceName: "ap.showcase")

        return Self (
            // Add user credentials to the Keychain
            storeToken: { data in
                keychainWrapper.set(data,
                                    forKey: UserKeychainClient.oauthTokenKey,
                                    withAccessibility: .always,
                                    isSynchronizable: true)
            },
            // Retrieve user credentials from the Keychain
            retrieveToken: {
                return keychainWrapper.string(forKey: UserKeychainClient.oauthTokenKey,
                                              withAccessibility: .always,
                                              isSynchronizable: true)
            },
            // Delete user credentials from the Keychain
            removeToken: {
                keychainWrapper.removeObject(
                    forKey: UserKeychainClient.oauthTokenKey,
                    withAccessibility: .always,
                    isSynchronizable: true
                )
            }
        )
    }()
}

private extension UserKeychainClient {
    // Key for storing OAuth token in the Keychain
    static let oauthTokenKey = "ap.showcase.OAuthToken"
}

