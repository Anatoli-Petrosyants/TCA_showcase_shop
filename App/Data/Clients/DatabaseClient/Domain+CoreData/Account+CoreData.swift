//
//  Account+CoreData.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.07.23.
//

import Foundation

// MARK: - Account + ManagedObjectConvertible

extension Account: ManagedObjectConvertible {
    static let entityName = "CDAccount"
    static var idKeyPath: KeyPath = \Self.id
    static let attributes: Set<Attribute<Account>> = [
        .init(\.id, "id"),
        .init(\.token, "token"),
        .init(\.firstName, "firstName"),
        .init(\.lastName, "lastName"),
        .init(\.birthDate, "birthDate"),
        .init(\.gender, "gender"),
        .init(\.email, "email"),
        .init(\.phone, "phone"),
        .init(\.enableNotifications, "enableNotifications"),        
    ]
}
