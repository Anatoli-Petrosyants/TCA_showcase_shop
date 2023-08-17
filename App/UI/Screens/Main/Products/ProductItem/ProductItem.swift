//
//  ProductItem.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.06.23.
//

import SwiftUI
import ComposableArchitecture

struct ProductItemReducer: Reducer {
    
    struct State: Equatable, Identifiable {
        let id: UUID
        let product: Product
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onItemTap
        }
        
        enum Delegate: Equatable {
            case didItemTapped(Product)
        }
        
        case view(ViewAction)
        case delegate(Delegate)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onItemTap:                    
                    return .send(.delegate(.didItemTapped(state.product)))
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
