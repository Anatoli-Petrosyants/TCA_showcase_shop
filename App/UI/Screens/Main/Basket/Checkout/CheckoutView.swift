//
//  CheckoutView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.09.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - BasketCheckoutView

struct CheckoutView {
    let store: StoreOf<CheckoutReducer>
}

// MARK: - Views

extension CheckoutView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section(header: Text("Select a Payment Method")) {
                    CheckoutCardOptionGroups(items: viewStore.cards) { card in
                        viewStore.send(.view(.onCardChange(card)))
                    }
                }
                .listRowBackground(Color.gray)
                
                
                Section(header: Text("Shipping address")) {
                    CheckoutAddressOptionGroups(items: viewStore.addresses) { address in
                        viewStore.send(.view(.onAddressChange(address)))
                    }
                }
                .listRowBackground(Color.gray)
                
                Button("Checkout") {
                    viewStore.send(.view(.onCheckoutButtonTap))
                }
                .buttonStyle(.cta)
            }
            .submitLabel(.done)
            .scrollContentBackground(.hidden)
            .tint(.black)
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("Checkout")
            .alert(store: self.store.scope(state: \.$alert, action: CheckoutReducer.Action.alert))
        }
    }
}
