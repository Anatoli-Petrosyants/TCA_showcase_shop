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
    
    func testProgressUpdated() async throws {
        let store = TestStore(initialState: LoadingReducer.State()) {
            LoadingReducer()
        }
        
        await store.send(.view(.onViewAppear))
        
        try await Task.sleep(for: .seconds(1))
        
        await store.receive(.internal(.onProgressUpdated)) {
            $0.progress = 0.01
        }
        
        await store.receive(.delegate(.didLoaded))
    }
}
