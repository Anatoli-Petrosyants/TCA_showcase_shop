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
    @Bindable var store: StoreOf<CheckoutFeature>
}

// MARK: - Views

extension CheckoutView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        Form {
            Section(header: Text(Localization.Basket.checkoutSelectPaymentMethod)) {
                CheckoutCardOptionGroups(items: store.cards) { card in
                    store.send(.view(.onCardChange(card)))
                }
            }
            .listRowBackground(Color.gray)
            
            
            Section(header: Text(Localization.Basket.checkoutShippingAddress)) {
                CheckoutAddressOptionGroups(items: store.addresses) { address in
                    store.send(.view(.onAddressChange(address)))
                }
            }
            .listRowBackground(Color.gray)
            
            Button(Localization.Basket.checkoutTitle) {
                store.send(.view(.onCheckoutButtonTap))
            }
            .buttonStyle(.cta)
        }
        .submitLabel(.done)
        .scrollContentBackground(.hidden)
        .tint(.black)
        .navigationTitle(Localization.Basket.checkoutTitle)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
