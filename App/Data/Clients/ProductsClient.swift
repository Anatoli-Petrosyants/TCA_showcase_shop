//
//  ProductsClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import Foundation
import Dependencies
import Get

/// A structure representing the products request parameters.
struct ProductsRequest: Encodable {
    var category: String

    init(category: String) {
        self.category = category
    }
}

/// An enumeration representing possible products errors.
enum ProductsError: Equatable, LocalizedError, Sendable {
    case notFound

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Products not found."
        }
    }
}

/// A client for handling products-related operations.
struct ProductsClient {
    /// A method for fetching all products.
    var products: @Sendable () async throws -> [Product]
    
    /// A method for fetching products with a specific category.
    var productsWithCategory: @Sendable (ProductsRequest) async throws -> [Product]
    
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
                var request = Request(path: "/products",
                                      method: .get)
                    .withResponse([ProductDTO].self)
                return try await apiClient.send(request).value.compactMap { $0.toEntity() }
            },
            productsWithCategory: { data in
                let category = data.category.isEmpty ? "" : "/category/\(data.category)"
                let path = (Configuration.current.baseURL + "/products" + category)
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    .valueOr("")
                
                guard let url = URL(string: path) else {
                    throw AppError.general
                }
                
                let urlRequest = URLRequest(url: url)
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw AppError.general
                }
                
                let productDTOs = try JSONDecoder().decode([ProductDTO].self, from: data)
                
                return productDTOs.compactMap { $0.toEntity() }
            },
            product: { productId in
                var request = Request(path: "/products/\(productId)",
                                      method: .get)
                    .withResponse(ProductDTO.self)
                return try await apiClient.send(request).value.toEntity()
            }
        )
    }()
}

