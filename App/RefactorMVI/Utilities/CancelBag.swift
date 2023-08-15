//
//  CancelBag.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Combine

final class CancelBag {

    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
