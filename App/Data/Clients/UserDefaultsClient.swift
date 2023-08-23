//
//  UserDefaultsClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import Dependencies
import Foundation

/// A client for interacting with UserDefaults.
struct UserDefaultsClient {
    /// A method to retrieve a boolean value for a given key.
    var boolForKey: @Sendable (String) -> Bool
    /// A method to set a boolean value for a given key.
    var setBool: @Sendable (Bool, String) async -> Void
    /// A method to retrieve a string value for a given key.
    var stringForKey: @Sendable (String) -> String?
    /// A method to set a string value for a given key.
    var setString: @Sendable (String, String) async -> Void
    /// A method to reset all stored values.
    var reset:  @Sendable () async -> Void
    
    /// A computed property indicating if the first launch onboarding has been shown.
    var hasShownFirstLaunchOnboarding: Bool {
        self.boolForKey(Self.hasShownFirstLaunchOnboardingKey)
    }
    
    /// A method to set the value indicating if the first launch onboarding has been shown.
    func setHasShownFirstLaunchOnboarding(_ bool: Bool) async {
        await self.setBool(bool, Self.hasShownFirstLaunchOnboardingKey)
    }
    
    /// A computed property for retrieving the stored token.
    var token: String? {
        self.stringForKey(Self.token)
    }
    
    /// A method to set the stored token.
    func setToken(_ string: String) async {
        await self.setString(string, Self.token)
    }
}

extension DependencyValues {
    /// Accessor for the UserDefaultsClient in the dependency values.
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

private extension UserDefaultsClient {
    static let hasShownFirstLaunchOnboardingKey = "hasShownFirstLaunchOnboardingKey"
    static let token = "token"
}

extension UserDefaultsClient: DependencyKey {
    /// A live implementation of UserDefaultsClient.
    static let liveValue: Self = {
        let defaults = { UserDefaults(suiteName: "group.showcase")! }
        return Self(
            boolForKey: { defaults().bool(forKey: $0) },
            setBool: { defaults().set($0, forKey: $1) },
            stringForKey: { defaults().string(forKey: $0) },
            setString: { defaults().set($0, forKey: $1) },
            reset: {
                // Remove all stored values.
                defaults().dictionaryRepresentation().keys.forEach { key in
                    defaults().removeObject(forKey: key)
                }
            }
        )
    }()
}

