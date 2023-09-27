//
//  EmailLoginTests.swift
//  ShowcaseTests
//
//  Created by Anatoli Petrosyants on 27.09.23.
//

import ComposableArchitecture
import XCTest
@testable import Showcase

@MainActor
final class EmailLoginTests: XCTestCase {
    
    func testEmailLoginSuccess() async {
        let store = TestStore(initialState: EmailLoginReducer.State()) {
            EmailLoginReducer()
        } withDependencies: {
            $0.authenticationClient.login = { _ in
                AuthenticationResponse(token: "email_token")
            }
        }
        
        await store.send(.view(.onSignInButtonTap)) {
            $0.username = "mor_2314"
            $0.password = "83r5^_"
            $0.isActivityIndicatorVisible = true
        }
        
        await store.receive(
            .internal(
                .loginResponse(
                    .failure(Error())
                )
            )
        )

//        await store.receive(
//            .internal(
//                .loginResponse(
//                    .success(AuthenticationResponse(token: "deadbeefdeadbeef"))
//                )
//            )
//        ) {
//            $0.isActivityIndicatorVisible = false
//        }
        
    }
}
