//
//  ProductUsersFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.06.23.
//

import SwiftUI
import ComposableArchitecture

struct ProductUsersFeature: Reducer {
    
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
