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
        var purchases: [Purchase] = []
    }
    
    enum Action: Equatable {
        case onAppear
        case queryChangedPurchases([Purchase])
    }
    
    @Dependency(\.purchaseDataClient) var context
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
//                do {
//                    let randomMovieName = ["Star Wars", "Harry Potter", "Hunger Games", "Lord of the Rings"].randomElement()!
//                    try context.add(.init(title: randomMovieName))
//                } catch {
//                    
//                }
                return .none
                
            case .queryChangedPurchases(let newPurchases):
                print("queryChangedPurchases", newPurchases)
                state.purchases = newPurchases
                return .none
            }
        }
    }
}
