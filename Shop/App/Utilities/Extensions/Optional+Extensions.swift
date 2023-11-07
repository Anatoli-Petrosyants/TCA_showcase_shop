//
//  Optional+Extensions.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

/// An extension on Optionals that provides a convenient method to access the wrapped value or a default value if the Optional is nil.
extension Optional {
    
    /// Returns the wrapped value if it exists, or a provided default value if the Optional is nil.
    ///
    /// This method is useful for safely unwrapping Optionals while providing a fallback value when the Optional is nil.
    ///
    /// - Parameters:
    ///   - defaultValue: The default value to use when the Optional is nil.
    /// - Returns: The wrapped value if it exists; otherwise, the provided default value.
    func valueOr(_ defaultValue: Wrapped) -> Wrapped {
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
