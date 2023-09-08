//
//  ProductsClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import Foundation
import Dependencies
import Moya

/// A client for handling products-related operations.
struct ProductsClient {
    /// A method for fetching all products.
    var products: @Sendable () async throws -> [Product]
    
    /// A method for fetching products with a specific category.
    var productsWithCategory: @Sendable (ProductsWithCategoryRequest) async throws -> [Product]
    
    /// A method for fetching a specific product by its ID.
    var product: @Sendable (Int) async throws -> Product
}

extension DependencyValues {
    /// Accessor for the ProductsClient in the dependency values.
    var productsClient: ProductsClient {
        get { self[ProductsClient.self] }
        set { self[ProductsClient.self] = newValue }
    }
}

extension ProductsClient: DependencyKey {
    /// A live implementation of ProductsClient.
    static let liveValue: Self = {
        return Self(
            products: {
                return try await API.provider.async.request(.products)
                    .map([ProductDTO].self)
                    .compactMap { $0.toEntity() }
            },
            productsWithCategory: { data in
                let request = ProductsWithCategoryRequest(category: data.category)
                return try await API.provider.async.request(.productsWithCategory(request))
                    .map([ProductDTO].self)
                    .compactMap { $0.toEntity() }
            },
            product: { productId in
                let request = ProductRequest(id: productId)
                return try await API.provider.async.request(.product(request))
                    .map(ProductDTO.self)
                    .toEntity()
            }
        )
    }()
}

