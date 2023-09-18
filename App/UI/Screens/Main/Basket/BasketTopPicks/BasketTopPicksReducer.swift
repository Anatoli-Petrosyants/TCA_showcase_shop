//
//  BasketTopPicksReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 15.09.23.
//

import SwiftUI
import ComposableArchitecture

struct BasketTopPicksReducer: Reducer {
    
    struct State: Equatable {
        var topPicks: [Product] = []
    }
    
    enum Action: Equatable {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
