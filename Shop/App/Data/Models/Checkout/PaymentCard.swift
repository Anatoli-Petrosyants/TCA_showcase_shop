//
//  PaymentCard.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.09.23.
//

import Foundation

struct PaymentCard: Identifiable, Equatable, Hashable {
    var id = UUID()
    /// Card holder name.
    var name: String
    /// The card number, as a string without any separators. Ex. @"4242424242424242"
    var number: String
    /// Number representing the card's expiration month. Ex. @1
    var expMonth: Int
    /// Two- or four-digit number representing the card's expiration year.
    var expYear: Int
    /// Card security code. It is highly recommended to always include this value.
    var cvc: Int
    // Default payment method
    var isDefaultPaymentMethod: Bool
}

extension PaymentCard {
    var last4: String {
        (number.count >= 4) ? String(number.suffix(4)) : ""
    }
}

extension PaymentCard {
    static let visa = PaymentCard(id: UUID(),
                                  name: "Anatoli Petrosyants",
                                  number: "4263982640269299",
                                  expMonth: Int.random(in: 1...12),
                                  expYear: Int.random(in: 2020...2023),
                                  cvc: Int.random(in: 1...3),
                                  isDefaultPaymentMethod: true)
    
    static let master = PaymentCard(id: UUID(),
                                    name: "Anatoli Petrosyants",
                                    number: "5425233430109903",
                                    expMonth: Int.random(in: 1...12),
                                    expYear: Int.random(in: 2020...2023),
                                    cvc: Int.random(in: 1...3),
                                    isDefaultPaymentMethod: false)
    
    static let discover = PaymentCard(id: UUID(),
                                      name: "Anatoli Petrosyants",
                                      number: "60115564485789458",
                                      expMonth: Int.random(in: 1...12),
                                      expYear: Int.random(in: 2020...2023),
                                      cvc: Int.random(in: 1...3),
                                      isDefaultPaymentMethod: false)
    
    static let diners = PaymentCard(id: UUID(),
                                    name: "Anatoli Petrosyants",
                                    number: "36700102000000",
                                    expMonth: Int.random(in: 1...12),
                                    expYear: Int.random(in: 2020...2023),
                                    cvc: Int.random(in: 1...3),
                                    isDefaultPaymentMethod: false)
    
    static let jcb = PaymentCard(id: UUID(),
                                 name: "Anatoli Petrosyants",
                                 number: "3528000700000000",
                                 expMonth: Int.random(in: 1...12),
                                 expYear: Int.random(in: 2020...2023),
                                 cvc: Int.random(in: 1...3),
                                 isDefaultPaymentMethod: false)
    
    static let mockedData: [PaymentCard] = [visa, master, discover, jcb]
}
