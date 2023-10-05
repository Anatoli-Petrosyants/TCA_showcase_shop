//
//  Loadable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.08.23.
//

import Foundation

// A generic enum representing the state of loading data.
enum Loadable<Value> {
    // Data has not been requested or loaded yet.
    case idle
    // Data is currently being loaded.
    case loading
    // Data has been successfully loaded.
    case loaded(Value)
    // Loading data has failed with an associated error.
    case failed(Error)
}

// A protocol for types that wrap a loadable value.
protocol LoadableValue {
    associatedtype Value
    var loadedValue: Value? { get }
}

// Conformance of Loadable to LoadableValue for types that have an Equatable wrapped value.
extension Loadable: LoadableValue where Value: Equatable {
    // Retrieve the loaded value if the state is .loaded, otherwise return nil.
    var loadedValue: Value? {
        guard case let .loaded(value) = self else { return nil }
        return value
    }
}

// Conformance of Loadable to Equatable for types that have an Equatable wrapped value.
extension Loadable: Equatable where Value: Equatable {
    // Compare two Loadable instances for equality.
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

