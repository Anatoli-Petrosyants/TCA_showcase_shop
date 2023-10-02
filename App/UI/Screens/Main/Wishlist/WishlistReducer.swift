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
        case actions(WishlistActionsReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.actions, action: /Action.actions) {
            WishlistActionsReducer()
        }
        
        Reduce { state, action in
            switch action {                
            case .actions(.delegate(.didRemoveTapped)):
                Log.debug("didRemoveTapped")
                return .none
                
            case .actions(.delegate(.didAddTapped)):
                Log.debug("didAddTapped")
                return .none
                
            case .actions:
                return .none
            }
        }
    }
}
