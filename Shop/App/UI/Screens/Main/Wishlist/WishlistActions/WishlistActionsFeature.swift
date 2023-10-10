//
//  WishlistActionsFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 02.10.23.
//

import SwiftUI
import ComposableArchitecture

struct WishlistActionsFeature: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onRemoveTap
            case onAddTap
        }
        
        enum Delegate: Equatable {
            case didRemoveTapped
            case didAddTapped
        }
        
        case view(ViewAction)
        case delegate(Delegate)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onRemoveTap):
                return .send(.delegate(.didRemoveTapped))
                
            case .view(.onAddTap):
                return .send(.delegate(.didAddTapped))
                
            case .delegate:
                return .none
            }
        }
    }
}
