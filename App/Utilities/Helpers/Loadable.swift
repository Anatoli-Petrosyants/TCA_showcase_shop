//
//  Loadable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.08.23.
//

import Foundation

enum Loadable<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(Error)
}

protocol LoadableValue {
    associatedtype Value
    var loadedValue: Value? { get }
}

extension Loadable: LoadableValue where Value: Equatable {
    var loadedValue: Value? {
        guard case let .loaded(value) = self else { return nil }
        return value
    }
}

extension Loadable: Equatable where Value: Equatable {
    static func == (lhs: Loadable<Value>, rhs: Loadable<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.failed, .failed):
            return true
        case let (.loaded(lhsValue), .loaded(rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}
