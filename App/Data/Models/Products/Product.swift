//
//  Product.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import Foundation

struct Product: Equatable, Hashable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let imageURL: URL
    let category: String
    let ratingStars: Float
    let ratingCount: Int
}

extension ProductDTO {
    
    func toEntity() -> Product {
        return .init(id: self.id,
                     title: self.title,
                     description: self.description,
                     price: self.price,
                     imageURL: URL(string: self.image)!,
                     category: self.category,
                     ratingStars: self.rating.rate,
                     ratingCount: self.rating.count)
    }
}
