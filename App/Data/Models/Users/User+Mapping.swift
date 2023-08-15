//
//  User+Mapping.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.06.23.
//

import Foundation

extension UserDTO {

    func toEntity() -> User {
        return .init(id: self.id,
                     name: self.firstname + " " + self.lastname,
                     email: self.email,
                     phone: self.phone)
    }
}
