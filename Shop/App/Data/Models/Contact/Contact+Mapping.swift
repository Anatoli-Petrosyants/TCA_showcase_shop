//
//  Contact+Mapping.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.09.23.
//

import Contacts

extension CNContact {
    
    func toContact() -> Contact {
        return Contact(firstName: self.givenName,
                       lastName: self.familyName,
                       organization: self.organizationName)
    }
}

extension Contact {
    
    func toCNContact() -> CNContact {
        let contact = CNMutableContact()
        contact.givenName = self.firstName
        contact.familyName = self.lastName
        contact.organizationName = self.organization
        return contact
    }
}
