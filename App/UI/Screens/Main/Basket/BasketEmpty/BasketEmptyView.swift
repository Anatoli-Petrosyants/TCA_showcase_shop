//
//  BasketEmptyView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 14.09.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ReducerView

struct BasketEmptyView {
    let store: StoreOf<BasketEmptyReducer>
}

// MARK: - Views

extension BasketEmptyView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Basket Empty")
        }
    }
}
