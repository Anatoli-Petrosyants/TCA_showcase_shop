//
//  Purchase.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 22.08.24.
//

import Foundation
import SwiftData

@Model 
class Purchase {
    let productId: Int
    let title: String
    
    init(productId: Int, title: String) {
        self.productId = productId
        self.title = title
    }
}
