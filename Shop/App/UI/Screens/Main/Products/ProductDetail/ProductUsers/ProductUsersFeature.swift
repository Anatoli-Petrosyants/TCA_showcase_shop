//
//  ProductUsersFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.06.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ProductUsersFeature {
    
    @ObservableState
    struct State: Equatable, Hashable {
        var items: [User] = []
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
