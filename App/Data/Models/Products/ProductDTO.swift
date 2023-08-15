//
//  ProductDTO.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import Foundation

struct ProductDTO: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: ProductRatingDTO
}

struct ProductRatingDTO: Decodable {
    let rate: Float
    let count: Int
}
