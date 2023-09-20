//
//  ShipmentAddress.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.09.23.
//

import Foundation

struct ShipmentAddress: Equatable, Hashable {
    let id: UUID
    let name: String
    let address: String
    var isSelected: Bool
    
    static let mockedData: [ShipmentAddress] = [
        ShipmentAddress(id: UUID(),
                        name: "Anatoli Petrosyants",
                        address: "1622 E AYRE ST, WILMINGTON",
                        isSelected: true),
        ShipmentAddress(id: UUID(),
                        name: "Anatoli Petrosyants",
                        address: "1623 E AYRE ST, WILMINGTON",
                        isSelected: false)
    ]
}
