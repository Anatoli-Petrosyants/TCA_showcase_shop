//
//  CheckoutReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.09.23.
//

import SwiftUI
import ComposableArchitecture

struct CheckoutReducer: Reducer {

    struct State: Equatable {
        var addresses = Address.mockedData
        var cards = PaymentCard.mockedData
    }
    
    enum Action: Equatable {
        case onAddressChange(Address)
        case onCardChange(PaymentCard)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onAddressChange(address):
                for (index, value) in state.addresses.enumerated() {
                    state.addresses[index].isSelected = value.id == address.id
                }                
                return .none
                
            case let .onCardChange(card):
                for (index, value) in state.cards.enumerated() {
                    state.cards[index].isDefaultPaymentMethod = value.id == card.id
                }
                return .none
            }
        }
    }
}

extension CheckoutReducer {
    
    struct Address: Equatable, Hashable {
        let id: UUID
        let name: String
        let address: String
        var isSelected: Bool
        
        static let mockedData: [Address] = [
            Address(id: UUID(),
                    name: "Anatoli Petrosyants",
                    address: "1622 E AYRE ST, WILMINGTON",
                    isSelected: true),
            Address(id: UUID(),
                    name: "Anatoli Petrosyants",
                    address: "1623 E AYRE ST, WILMINGTON",
                    isSelected: false)
        ]
    }
}

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
                                  name: "Mari Kalkun",
                                  number: "4242424242424242",
                                  expMonth: Int.random(in: 1...12),
                                  expYear: Int.random(in: 2020...2023),
                                  cvc: Int.random(in: 1...3),
                                  isDefaultPaymentMethod: true)
    
    static let master = PaymentCard(id: UUID(),
                                    name: "Anatoli Petrosyants",
                                    number: "5555555555554444",
                                    expMonth: Int.random(in: 1...12),
                                    expYear: Int.random(in: 2020...2023),
                                    cvc: Int.random(in: 1...3),
                                    isDefaultPaymentMethod: false)
    
    static let discover = PaymentCard(id: UUID(),
                                      name: "Anatoli Petrosyants",
                                      number: "6011111111111117",
                                      expMonth: Int.random(in: 1...12),
                                      expYear: Int.random(in: 2020...2023),
                                      cvc: Int.random(in: 1...3),
                                      isDefaultPaymentMethod: false)
    
    static let mockedData: [PaymentCard] = [visa, master, discover]
}
