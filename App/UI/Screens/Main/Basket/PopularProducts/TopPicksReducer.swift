//
//  TopPicksReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.09.23.
//

import SwiftUI
import ComposableArchitecture

struct TopPicksReducer: Reducer {
    
    struct State: Equatable {
        var products: [Product] = []
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onItemTap(Product)
        }
        
        enum Delegate: Equatable {
            case didItemTapped(Product)
        }

        case view(ViewAction)
        case delegate(Delegate)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                Log.debug("PopularProductsReducer onViewAppear")
                return .none
            }
        }
    }
}


