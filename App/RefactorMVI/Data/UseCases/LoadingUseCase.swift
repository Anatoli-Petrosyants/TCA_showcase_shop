//
//  LoadingUseCase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.04.23.
//

import Foundation

protocol LoadingUseCaseProtocol {
    func execute() async throws -> Bool
}

class LoadingUseCase: AsyncThrowsUseCase<Bool>,
                      LoadingUseCaseProtocol {
    
    override func execute() async throws -> Bool {
        try await Task.sleep(for: .seconds(1))
        return true
    }
}


