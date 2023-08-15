//
//  Repository.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

class RepositoryCompletableBase<ParamsT, DataT, ErrorT: Error> {
    func execute(params: ParamsT,
                 completion: ResultBlock<DataT, ErrorT>?) {
        fatalError("Need override func: \(#function), in \(String(describing: self))")
    }
}

class RepositoryCompletableBaseWithoutParams<DataT, ErrorT: Error> {
    func execute(completion: ResultBlock<DataT, ErrorT>?) {
        fatalError("Need override func: \(#function), in \(String(describing: self))")
    }
}

class RepositoryCompletableBaseWithoutResponse<ErrorT: Error> {
    func executeWithoutResponse(completion: Block<ErrorT?>?) {
        fatalError("Need override func: \(#function), in \(String(describing: self))")
    }
}
