//
//  ProductsAPIRepository.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import Foundation
import Alamofire

class ProductsAPIRepository {

}

extension ProductsAPIRepository: ProductsRepositoryProtocol {
    
    func fetch(completion: ResultBlock<[Product], Error>?) {
        let url = URL(string: "https://fakestoreapi.com/products")!
        AF.request(url)
            .validate()
            .responseDecodable(of: [ProductDTO].self) { response in
                guard let products = response.value else {
                    completion?(.failure(response.error!))
                    return
                }

                let models = products.compactMap { $0.toEntity() }
                completion?(.success(models))
            }
    }
}
