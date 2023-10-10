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
    let store: StoreOf<CheckoutFeature>
}

// MARK: - Views

extension CheckoutView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section(header: Text(Localization.Basket.checkoutSelectPaymentMethod)) {
                    CheckoutCardOptionGroups(items: viewStore.cards) { card in
                        viewStore.send(.view(.onCardChange(card)))
                    }
                }
                .listRowBackground(Color.gray)
                
                
                Section(header: Text(Localization.Basket.checkoutShippingAddress)) {
                    CheckoutAddressOptionGroups(items: viewStore.addresses) { address in
                        viewStore.send(.view(.onAddressChange(address)))
                    }
                }
                .listRowBackground(Color.gray)
                
                Button(Localization.Basket.checkoutTitle) {
                    viewStore.send(.view(.onCheckoutButtonTap))
                }
                .buttonStyle(.cta)
            }
            .submitLabel(.done)
            .scrollContentBackground(.hidden)
            .tint(.black)
            // .toolbar(.hidden, for: .tabBar)
            .navigationTitle(Localization.Basket.checkoutTitle)
            .alert(store: self.store.scope(state: \.$alert, action: CheckoutFeature.Action.alert))
        }
    }
}
