//
//  FavoriteButtonFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.07.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct FavoriteButtonFeature {
    
    @ObservableState
    struct State: Equatable {
        let id = UUID()
        var isFavorite: Bool = false
    }
    
    enum Action: Equatable {
        case onTap
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onTap:
                state.isFavorite.toggle()
                return .none
            }
        }
    }
}
