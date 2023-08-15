//
//  ProductsUseCase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import Foundation
import Dependencies

struct ProductsUseCase {
    let repository = ProductsAPIRepository()

    func fetchProducts() async throws -> [Product] {
        return try await withCheckedThrowingContinuation { continuation in
            repository.fetch { result in
                switch result {
                case let .success(data):
                    continuation.resume(with: .success(data))

                case let .failure(error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}

//struct ProductsUseCase {
//    var fetchProducts:  @Sendable () async throws -> [Product]
//}
//
//extension ProductsUseCase {
//
//    static let liveValue = Self(
//        fetchProducts: {
//            let repository = ProductsAPIRepository()
//            return try await withCheckedThrowingContinuation { continuation in
//                repository.fetch { result in
//                    switch result {
//                    case let .success(data):
//                        continuation.resume(with: .success(data))
//
//                    case let .failure(error):
//                        continuation.resume(with: .failure(error))
//                    }
//                }
//            }
//        }
//    )
//
//    static let testValue = Self(
//        fetchProducts: {
//            ProductDTO.mockedData.compactMap { $0.toEntity() }
//        }
//    )
//}
