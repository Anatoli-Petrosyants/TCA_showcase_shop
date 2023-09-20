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
                    .foregroundColor(item.isDefaultPaymentMethod ? .blue : .gray)
                    .imageScale(.large)
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "creditcard")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.gray)
                        .frame(width: 36, height: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Brand Name" + " " + "••••" + item.last4)
                            .foregroundColor(.black)
                            .font(.subheadlineBold)
                        
                        Text(item.name + " " + "\(item.expMonth)/\(item.expYear)")
                            .foregroundColor(.black05)
                            .font(.subheadline)
                        
                        Spacer()
                    }

                    Spacer()
                }
                .padding(.top, 12)
            }
            .foregroundColor(.primary)
        }
    }
}
