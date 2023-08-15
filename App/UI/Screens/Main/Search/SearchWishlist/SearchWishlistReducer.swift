//
//  SearchWishlistReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.07.23.
//

import SwiftUI
import ComposableArchitecture

struct SearchWishlistReducer: ReducerProtocol {
    
    struct State: Equatable, Hashable {
        var count: Int = 0
    }
    
    enum Action: Equatable {
        case onViewAppear
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none
            }
        }
    }
}
