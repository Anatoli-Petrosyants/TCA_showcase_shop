//
//  SearchFavoriteButtonReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.07.23.
//

import SwiftUI
import ComposableArchitecture

struct SearchFavoriteButtonReducer: Reducer {
    
    struct State: Equatable, Identifiable {
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
