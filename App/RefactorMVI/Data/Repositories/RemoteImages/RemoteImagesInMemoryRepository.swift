//
//  RemoteImagesInMemoryRepository.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import Foundation

class RemoteImagesInMemoryRepository {
    let images: [RemoteImageDTO]
    
    init() {
        self.images = RemoteImageDTO.mockedData
    }
}

extension RemoteImagesInMemoryRepository: RemoteImagesRepositoryProtocol {
    
    func components(completion: ResultBlock<[RemoteImage]?, Error>?) {
        if images.isEmpty {
            // completion?(.failure(<#T##Error#>))
        } else {
            let models = images.compactMap { $0.toEntity() }
            completion?(.success(models))
        }
    }
}
