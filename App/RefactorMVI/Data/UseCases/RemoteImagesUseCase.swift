//
//  RemoteImagesUseCase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import Foundation

protocol RemoteImagesUseCaseProtocol {
    func execute(completion: ResultBlock<[RemoteImage]?, Error>?)
}

class RemoteImagesUseCase: UseCaseCompletableBaseWithoutParams<[RemoteImage]?, Error>,
                           RemoteImagesUseCaseProtocol {

    let repository: RemoteImagesRepositoryProtocol
    
    init(repository: RemoteImagesRepositoryProtocol) {
        self.repository = repository
    }
    
    override func execute(completion: ResultBlock<[RemoteImage]?, Error>?) {
        repository.components(completion: completion)
    }
}
