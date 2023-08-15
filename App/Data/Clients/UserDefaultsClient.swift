//
//  UserDefaultsClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import Dependencies
import Foundation

extension DependencyValues {
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

struct UserDefaultsClient {
    var boolForKey: @Sendable (String) -> Bool
    var setBool: @Sendable (Bool, String) async -> Void
    var stringForKey: @Sendable (String) -> String?
    var setString: @Sendable (String, String) async -> Void
    var reset:  @Sendable () async -> Void
    
    var hasShownFirstLaunchOnboarding: Bool {
        self.boolForKey(Self.hasShownFirstLaunchOnboardingKey)
    }
    
    func setHasShownFirstLaunchOnboarding(_ bool: Bool) async {
        await self.setBool(bool, Self.hasShownFirstLaunchOnboardingKey)
    }
    
    var token: String? {
        self.stringForKey(Self.token)
    }
    
    func setToken(_ string: String) async {
        await self.setString(string, Self.token)
    }
}

private extension UserDefaultsClient {
    static let hasShownFirstLaunchOnboardingKey = "hasShownFirstLaunchOnboardingKey"
    static let token = "token"
}

extension UserDefaultsClient: DependencyKey {
    static let liveValue: Self = {
        let defaults = { UserDefaults(suiteName: "group.showcase")! }
        return Self(
            boolForKey: { defaults().bool(forKey: $0) },
            setBool: { defaults().set($0, forKey: $1) },
            stringForKey: { defaults().string(forKey: $0) },
            setString: { defaults().set($0, forKey: $1) },
            reset: {
                defaults().dictionaryRepresentation().keys.forEach { key in
                    defaults().removeObject(forKey: key)
                }
            }
        )
    }()
}
