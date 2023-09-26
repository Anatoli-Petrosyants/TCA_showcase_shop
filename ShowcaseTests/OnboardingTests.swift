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
    
    func testShowGetStartButton() async {
        let store = TestStore(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        } withDependencies: {
            $0.userDefaults = UserDefaultsClient.testValue
        }

        await store.send(.onTabChanged(tab: .page3)) {
            $0.selectedTab = .page3
            $0.showGetStarted = ($0.selectedTab == .page3)
        }
        
        XCTAssertTrue(store.state.showGetStarted)
    }
}
