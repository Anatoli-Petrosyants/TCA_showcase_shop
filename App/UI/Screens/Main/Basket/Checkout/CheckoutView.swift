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
                    CheckoutAddressOptionGroups(items: viewStore.addresses) { address in
                        viewStore.send(.onAddresschange(address))
                    }
                }
                .listRowBackground(Color.gray)
                
                Section(header: Text("Shipping address")) {
                    CheckoutAddressOptionGroups(items: viewStore.addresses) { address in
                        viewStore.send(.onAddresschange(address))
                    }
                }
                .listRowBackground(Color.gray)
            }
            .submitLabel(.done)
            .scrollContentBackground(.hidden)
            .tint(.black)
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("Checkout")
        }
    }
}

struct CheckoutAddressOptionGroups: View {
    typealias Address = CheckoutReducer.CheckoutAddress
    
    var items: [Address]
    let callback: (Address) -> ()
    
    var body: some View {
        ForEach(items, id: \.self) { item in
            CheckoutAddressOption(item: item) {
                callback(item)
            }
        }
    }
}

struct CheckoutAddressOption: View {
    var item: CheckoutReducer.CheckoutAddress
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: item.isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(item.isSelected ? .blue : .gray)
                    .imageScale(.large)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .foregroundColor(.black)
                        .font(.subheadlineBold)
                    
                    Text(item.address)
                        .foregroundColor(.black05)
                        .font(.subheadline)
                }
            }
            .foregroundColor(.primary)
        }
    }
}
