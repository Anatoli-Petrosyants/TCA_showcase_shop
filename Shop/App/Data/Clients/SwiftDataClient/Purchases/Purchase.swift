//
//  Purchase.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 22.08.24.
//

import Foundation
import SwiftData

enum PurchaseSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Purchase.self]
    }

    @Model
    class Purchase: Identifiable {
        var id: UUID
        var title: String
        
        init(title: String) {
            self.id = UUID()
            self.title = title
        }
    }
}

typealias Purchase = PurchaseSchemaV1.Purchase
