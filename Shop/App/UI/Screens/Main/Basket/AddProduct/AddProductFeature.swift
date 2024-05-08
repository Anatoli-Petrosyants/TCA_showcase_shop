//
//  AddProductFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 14.09.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AddProductFeature {
    
    struct State {
        
    }
    
    enum Action {
        enum ViewAction: Equatable {            
            case onAddProductsButtonTap
        }
        
        enum Delegate: Equatable {
            case didAddProductsTapped
        }

        case view(ViewAction)
        case delegate(Delegate)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAddProductsButtonTap):
                return .send(.delegate(.didAddProductsTapped))

            case .delegate:
                return .none
            }
        }
    }
}
