//
//  LoadingTests.swift
//  ShowcaseTests
//
//  Created by Anatoli Petrosyants on 26.09.23.
//

import ComposableArchitecture
import XCTest
@testable import Showcase

@MainActor
final class LoadingTests: XCTestCase {
    
    func testProgressUpdated() async {
        let store = TestStore(initialState: LoadingReducer.State()) {
            LoadingReducer()
        }
                
    }
}
