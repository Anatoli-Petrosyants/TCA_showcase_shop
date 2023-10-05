//
//  ProductsWithCategoryRequest.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import Foundation

struct ProductsWithCategoryRequest: Encodable {
    let category: String
    
    init(category: String) {
        self.category = category
    }
}
