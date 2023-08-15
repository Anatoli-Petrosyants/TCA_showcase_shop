//
//  ProductUsers.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.06.23.
//

import SwiftUI
import ComposableArchitecture

struct ProductUsers: ReducerProtocol {
    
    struct State: Equatable, Hashable {
        var items: [User] = []
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
