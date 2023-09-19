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
        var addresses = CheckoutAddress.mockedData
    }
    
    enum Action: Equatable {
        case onAddresschange(CheckoutAddress)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onAddresschange(address):
                for (index, value) in state.addresses.enumerated() {
                    state.addresses[index].isSelected = value.id == address.id
                }                
                return .none
            }
        }
    }
}

extension CheckoutReducer {
    
    struct CheckoutAddress: Equatable, Hashable {
        let id: UUID
        let name: String
        let address: String
        var isSelected: Bool
        
        static let mockedData: [CheckoutAddress] = [
            CheckoutAddress(id: UUID(),
                            name: "Anatoli Petrosyants",
                            address: "1622 E AYRE ST ARM11111, WILMINGTON",
                            isSelected: true),
            CheckoutAddress(id: UUID(),
                            name: "Anatoli Petrosyants",
                            address: "1622 E AYRE ST ARM22222, WILMINGTON",
                            isSelected: false)
        ]
    }
}
