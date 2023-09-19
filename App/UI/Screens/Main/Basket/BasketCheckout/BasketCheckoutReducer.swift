//
//  BasketCheckoutReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.09.23.
//

import SwiftUI
import ComposableArchitecture

struct BasketCheckoutReducer: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case onViewAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none
            }
        }
    }
}
