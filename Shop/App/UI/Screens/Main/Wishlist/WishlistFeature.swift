//
//  WishlistFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.09.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct WishlistFeature {

    @ObservableState
    struct State {
        var products: [Product] = []
        var actions = WishlistActionsFeature.State()
    }
    
    enum Action {
        enum InternalAction: Equatable {
            case removeItem
        }
        
        enum Delegate: Equatable {
            case didProductAddedToBasket(Product)
            case didProductRemovedFromFavorites(Product)
        }

        case `internal`(InternalAction)
        case delegate(Delegate)
        case actions(WishlistActionsFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.actions, action: /Action.actions) {
            WishlistActionsFeature()
        }
        
        Reduce { state, action in
            switch action {                
            case .actions(.delegate(.didRemoveTapped)):
                return .concatenate(
                    .send(.delegate(.didProductRemovedFromFavorites(state.products.first!))),
                    .send(.internal(.removeItem))
                )
                
            case .actions(.delegate(.didAddTapped)):
                return .concatenate(
                    .send(.delegate(.didProductRemovedFromFavorites(state.products.first!))),
                    .send(.delegate(.didProductAddedToBasket(state.products.first!))),
                    .send(.internal(.removeItem))
                )
                
            case .internal(.removeItem):
                state.products.removeFirst()
                return .none
                
            case .actions, .delegate:
                return .none
            }
        }
    }
}
