//
//  SearchProductItemReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.07.23.
//

import SwiftUI
import ComposableArchitecture

struct SearchProductItemReducer: ReducerProtocol {
    
    struct State: Equatable, Identifiable {
        let id: UUID
        let product: Product
        var favorite = SearchFavoriteButtonReducer.State()
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onItemTap
        }
        
        enum Delegate: Equatable {
            case didItemTapped(Product)
            case didFavoriteTapped(Bool)
        }

        case view(ViewAction)
        case delegate(Delegate)
        case favorite(SearchFavoriteButtonReducer.Action)
    }
    
    @Dependency(\.feedbackGenerator) var feedbackGenerator
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.favorite, action: /Action.favorite) {
            SearchFavoriteButtonReducer()
        }
    
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onItemTap:
                    return .send(.delegate(.didItemTapped(state.product)))
                }
                
            case let .favorite(favoriteAction):
                switch favoriteAction {
                case .onTap:
//                    let isFavorite = state.favorite.isFavorite
//                    return .send(.delegate(.didFavoriteTapped(isFavorite)))
                    
                    return .task { [isFavorite = state.favorite.isFavorite] in
                        await self.feedbackGenerator.selectionChanged()
                        return .delegate(.didFavoriteTapped(isFavorite))
                    }
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
