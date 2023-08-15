//
//  Optional+Extensions.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

extension Optional {
    
    func valueOr(_ defaultValue: Wrapped)-> Wrapped {
        return self ?? defaultValue
    }
}

/// Allows to match for optionals with generics that are defined as non-optional.
public protocol AnyOptional {

    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    
    public var isNil: Bool { self == nil }
}
