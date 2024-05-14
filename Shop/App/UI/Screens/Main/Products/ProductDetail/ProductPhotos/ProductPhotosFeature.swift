//
//  ProductPhotosFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

@Reducer
struct ProductPhotosFeature {
    
    @ObservableState
    struct State: Equatable {
        var urls: [String] = []
    }

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
