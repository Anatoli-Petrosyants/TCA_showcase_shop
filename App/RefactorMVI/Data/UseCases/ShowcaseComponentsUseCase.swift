//
//  ShowcaseComponentsUseCase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

protocol ShowcaseComponentsUseCaseProtocol {
    func execute(completion: ResultBlock<[Component]?, Error>?)
}

class ShowcaseComponentsUseCase: UseCaseCompletableBaseWithoutParams<[Component]?, Error>,
                                 ShowcaseComponentsUseCaseProtocol {

    let repository: ShowcaseComponentsRepositoryProtocol
    
    init(repository: ShowcaseComponentsRepositoryProtocol) {
        self.repository = repository
    }
    
    override func execute(completion: ResultBlock<[Component]?, Error>?) {
        repository.components(completion: completion)
    }
}
