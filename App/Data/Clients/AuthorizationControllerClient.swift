//
//  AuthorizationControllerClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.09.23.
//

// [WiP] Continue development after configuring project bundle id wirh apple team. A.P.

import Foundation
import ComposableArchitecture
import AuthenticationServices

struct AuthorizationControllerClient {
    var signIn: @Sendable () async throws -> Void
}

extension DependencyValues {
    var authorizationControllerClient: AuthorizationControllerClient {
        get { self[AuthorizationControllerClient.self] }
        set { self[AuthorizationControllerClient.self] = newValue }
    }
}

extension AuthorizationControllerClient: DependencyKey {
    
    static let liveValue: AuthorizationControllerClient = {
        return Self(
            signIn: {
                Log.debug("AuthorizationControllerClient signIn")
                
                // Create an authorization request
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]

                // Create the authorization controller
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = AuthorizationControllerDelegateAdapter(callback: { result in
                    Log.debug("AuthorizationControllerClient result \(result)")
                })

                // Present the authorization controller
                authorizationController.performRequests()
            }
        )
    }()
}

class AuthorizationControllerDelegateAdapter: NSObject, ASAuthorizationControllerDelegate {

    private let callback: (Result<Void, Error>) -> Void
    
    init(callback: @escaping (Result<Void, Error>) -> Void) {
        self.callback = callback
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            // let fullName = appleIDCredential.fullName
            // let email = appleIDCredential.email
            Log.debug("AuthorizationControllerDelegateAdapter \(userIdentifier)")
            callback(.success(()))

        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Log.error("AuthorizationControllerDelegateAdapter \(error.localizedDescription)")
        callback(.failure(error))
    }
}
