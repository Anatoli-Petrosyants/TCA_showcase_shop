//
//  Contact.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.09.23.
//

import Contacts

struct Contact: Equatable, Identifiable, Hashable {
    let id: UUID = UUID()
    var firstName: String
    var lastName: String
    var organization: String
}
