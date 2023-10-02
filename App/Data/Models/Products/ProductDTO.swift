//
//  ProductDTO.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import Foundation

struct ProductDTO: Decodable {
    let productId: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: ProductRatingDTO
    
    enum CodingKeys: String, CodingKey {
        case productId = "id"
        case title, price, description, category, image, rating
    }
}

struct ProductRatingDTO: Decodable {
    let rate: Float
    let count: Int
}
