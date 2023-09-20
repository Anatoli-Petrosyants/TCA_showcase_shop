//
//  CheckoutAddressView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.09.23.
//

import SwiftUI

struct CheckoutAddressOptionGroups: View {
    typealias Address = CheckoutReducer.Address
    
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
    var item: CheckoutReducer.Address
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
