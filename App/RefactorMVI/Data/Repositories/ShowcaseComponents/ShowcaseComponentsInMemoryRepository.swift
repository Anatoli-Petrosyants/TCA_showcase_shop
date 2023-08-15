//
//  ShowcaseComponentsInMemoryRepository.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

class ShowcaseComponentsInMemoryRepository {
    let components: [ComponentDTO]
    
    init() {
        self.components = ComponentDTO.mockedData
    }
}

extension ShowcaseComponentsInMemoryRepository: ShowcaseComponentsRepositoryProtocol {
    
    func components(completion: ResultBlock<[Component]?, Error>?) {
        if components.isEmpty {            
            // completion?(.failure(<#T##Error#>))
        } else {
            let models = components.compactMap { $0.toEntity() }
            completion?(.success(models))
        }
    }
}
