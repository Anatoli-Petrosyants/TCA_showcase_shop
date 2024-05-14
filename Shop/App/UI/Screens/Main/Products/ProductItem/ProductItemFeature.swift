//
//  ProductItem.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.06.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ProductItemFeature {
    
    @ObservableState
    struct State: Identifiable {
        let id: UUID
        let product: Product
        var favorite = FavoriteButtonFeature.State()
    }
    
    enum Action {
        enum ViewAction {
            case onItemTap            
        }
        
        enum Delegate {
            case didItemTapped(Product)
            case didFavoriteChanged(Bool, Product)
        }
        
        case view(ViewAction)
        case delegate(Delegate)
        case favorite(FavoriteButtonFeature.Action)
    }
    
    @Dependency(\.feedbackGenerator) var feedbackGenerator
    
    var body: some Reducer<State, Action> {
        Scope(state: \.favorite, action: /Action.favorite) {
            FavoriteButtonFeature()
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
                    return .run { [isFavorite = state.favorite.isFavorite, product = state.product] send in
                        await self.feedbackGenerator.selectionChanged()
                        return await send(.delegate(.didFavoriteChanged(isFavorite, product)))
                    }
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
