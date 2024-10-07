//
//  GoogleSignInClient.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 07.10.24.
//

import Foundation
import Dependencies
import UIKit
import GoogleSignIn

/// A client for handling authentication operations.
struct GoogleSignInClient {
    /// A method for performing login using the provided credentials.
    var login: (UIViewController) async throws -> AuthenticationResponse
    var logout: () -> Void
}

extension DependencyValues {
    /// Accessor for the GoogleSignInClient in the dependency values.
    var googleSignInClient: GoogleSignInClient {
        get { self[GoogleSignInClient.self] }
        set { self[GoogleSignInClient.self] = newValue }
    }
}

extension GoogleSignInClient: DependencyKey {
    /// A live implementation of GoogleSignInClient.
    
    static let liveValue: Self = {
        return Self(
            login: { rootViewController in
//                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
//                    guard let result = signInResult else {
//                        Log.debug("GIDSignIn error \(error?.localizedDescription)")
//                        return
//                    }
//
//                    // If sign in succeeded, display the app's main content View.
//                    Log.debug("GIDSignIn signInResult \(signInResult)")
//                }
                                             
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                
                let user = result.user.profile
                
                guard let email = user?.email else {
                    throw AuthenticationError.invalidEmail
                }
                
                let username = "mor_2314"
                let password = "83r5^_"
                
                let request = LoginEmailRequest(username: username, password: password)
                return try await API.provider.async.request(.login(request))
                    .map(AuthenticationResponse.self)
            },
            logout: {
                GIDSignIn.sharedInstance.signOut()
            }
        )
    }()
}

extension GoogleSignInClient: TestDependencyKey {
    static let testValue = Self(
        login: unimplemented("\(Self.self).login"),
        logout: unimplemented("\(Self.self).logout")
    )
}

