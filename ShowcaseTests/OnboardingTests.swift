//
//  OnboardingTests.swift
//  ShowcaseTests
//
//  Created by Anatoli Petrosyants on 25.09.23.
//

import ComposableArchitecture
import XCTest
@testable import Showcase

@MainActor
final class OnboardingTests: XCTestCase {
    
    func testGetStartButtonVisibility() async {
        let store = TestStore(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        }
        
        await store.send(.view(.onTabChanged(tab: .page3))) {
            $0.currentTab = .page3
        }
        
        // XCTAssertEqual(store.state.currentTab, .page3)
        XCTAssertTrue(store.state.showGetStarted)
    }

//    func testGetStartButtonVisibility() async {
//        let store = TestStore(initialState: OnboardingReducer.State()) {
//            OnboardingReducer()
//        }
//
//        await store.onTabChanged(.page1) {
//            $0
//        }
//    }
}

//import XCTest
//import ComposableArchitecture
//
//@MainActor
//final class OnboardingTests: XCTestCase {
//
//    func testExample() throws {
//        XCTAssertTrue(true)
//    }
//
//    func testGetStartButtonVisibility() async {
//        let store = TestStore(initialState: OnboardingReducer.State()) {
//            OnboardingReducer()
//        }
//    }
//}
