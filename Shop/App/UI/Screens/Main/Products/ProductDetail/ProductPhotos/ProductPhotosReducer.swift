//
//  ProductPhotosReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct ProductPhotosReducer: Reducer {
    
    // MARK: State
    
    struct State: Equatable {
        var urls: [String] = []
    }
    
    // MARK: Action
    
    enum Action: Equatable {
        case onCloseTap
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onCloseTap:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
