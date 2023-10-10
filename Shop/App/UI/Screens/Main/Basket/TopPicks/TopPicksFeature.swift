//
//  TopPicksFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.09.23.
//

import SwiftUI
import ComposableArchitecture

struct TopPicksFeature: Reducer {
    
    struct State: Equatable {
        var products: [Product] = []
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onItemTap(Product)
        }
        
        enum Delegate: Equatable {
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


