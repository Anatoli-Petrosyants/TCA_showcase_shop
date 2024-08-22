//
//  PurchaseHistoryFeature.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 22.08.24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct PurchaseHistoryFeature {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
