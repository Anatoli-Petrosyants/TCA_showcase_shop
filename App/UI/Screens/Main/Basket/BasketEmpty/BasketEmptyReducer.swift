//
//  BasketEmptyReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 14.09.23.
//

import SwiftUI
import ComposableArchitecture

struct BasketEmptyReducer: Reducer {
    
    struct State: Equatable, Hashable {
        
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
