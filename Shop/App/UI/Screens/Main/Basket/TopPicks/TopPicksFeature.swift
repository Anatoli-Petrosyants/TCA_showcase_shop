//
//  TopPicksFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.09.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TopPicksFeature {
    
    @ObservableState
    struct State {
        var products: [Product] = []
    }
    
    enum Action {
        enum ViewAction {
            case onItemTap(Product)
        }
        
        enum Delegate {
            case didItemSelected(Product)
        }

        case view(ViewAction)
        case delegate(Delegate)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(.onItemTap(product)):
                return .send(.delegate(.didItemSelected(product)))
                
            case .delegate:
                return .none
            }
        }
    }
}


