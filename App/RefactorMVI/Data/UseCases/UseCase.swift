//
//  UseCase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

class UseCaseCompletableBase<ParamsT, DataT, ErrorT: Error> {
    func execute(params: ParamsT,
                 completion: ResultBlock<DataT, ErrorT>?) {
        fatalError("Need override func: \(#function), in \(String(describing: self))")
    }
}

class UseCaseCompletableBaseWithoutParams<DataT, ErrorT: Error> {
    func execute(completion: ResultBlock<DataT, ErrorT>?) {
        fatalError("Need override func: \(#function), in \(String(describing: self))")
    }
}

class UseCaseCompletableBaseWithoutResponse<ErrorT: Error> {
    func executeWithoutResponse(completion: Block<ErrorT?>?) {
        fatalError("Need override func: \(#function), in \(String(describing: self))")
    }
}


// MARK: Async Throws UseCase

class AsyncThrowsUseCase<Data> {
    func execute() async throws -> Data {
        fatalError("Need override func: \(#function), in \(String(describing: self))")
    }
}

class AsyncThrowsUseCaseWithParameter<Param, Data> {
    func execute(params: Param) async throws -> Data {
        fatalError("Need override func: \(#function), in \(String(describing: self))")
    }
}

class AsyncThrowsUseCaseWithoutResponse {
    func execute() async throws {
        fatalError("Need override func: \(#function), in \(String(describing: self))")
    }
}
