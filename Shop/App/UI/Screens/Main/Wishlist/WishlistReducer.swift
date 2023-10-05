//
//  WishlistReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.09.23.
//

import SwiftUI
import ComposableArchitecture

struct WishlistReducer: Reducer {

    struct State: Equatable {
        var products: [Product] = []
        var actions = WishlistActionsReducer.State()
    }
    
    enum Action: Equatable {
        enum InternalAction: Equatable {
            case removeItem
        }
        
        enum Delegate: Equatable {
            case didProductAddedToBasket(Product)
            case didProductRemovedFromFavorites(Product)
        }

        case `internal`(InternalAction)
        case delegate(Delegate)
        case actions(WishlistActionsReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.actions, action: /Action.actions) {
            WishlistActionsReducer()
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
