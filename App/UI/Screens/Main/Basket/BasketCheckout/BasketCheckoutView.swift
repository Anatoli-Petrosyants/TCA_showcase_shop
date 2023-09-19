//
//  BasketCheckoutView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.09.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - BasketCheckoutView

struct BasketCheckoutView {
    let store: StoreOf<BasketCheckoutReducer>
}

// MARK: - Views

extension BasketCheckoutView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("BasketCheckout view")
        }
    }
}
