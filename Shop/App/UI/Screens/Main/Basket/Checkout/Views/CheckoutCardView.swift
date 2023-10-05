//
//  CheckoutCardView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.09.23.
//

import SwiftUI

struct CheckoutCardOptionGroups: View {
    
    var items: [PaymentCard]
    let callback: (PaymentCard) -> ()
    
    var body: some View {
        ForEach(items, id: \.self) { item in
            CheckoutCardOption(item: item) {
                callback(item)
            }
        }
    }
}

struct CheckoutCardOption: View {
    var item: PaymentCard
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: item.isDefaultPaymentMethod ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(item.isDefaultPaymentMethod ? .blue : .black03)
                    .imageScale(.large)
                
                Image(item.number.cardBrand.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(item.number.cardBrand.rawValue)" + " " + "••••" + item.last4)
                        .foregroundColor(.black)
                        .font(.subheadlineBold)
                    
                    Text(item.name + " " + "\(item.expMonth)/\(item.expYear)")
                        .foregroundColor(.black05)
                        .font(.subheadline)
                }
            }
            .foregroundColor(.primary)
        }
    }
}
