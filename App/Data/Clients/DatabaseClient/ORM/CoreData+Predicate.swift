//
//  CoreData+Predicate.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.07.23.
//

import Foundation

// MARK: - PredicateProtocol

public protocol PredicateProtocol<Root>: NSPredicate {
    associatedtype Root: ManagedObjectConvertible
}

// MARK: - CompoundPredicate

public final class CompoundPredicate<Root: ManagedObjectConvertible>: NSCompoundPredicate, PredicateProtocol {}

// MARK: - ComparisonPredicate

public final class ComparisonPredicate<Root: ManagedObjectConvertible>: NSComparisonPredicate, PredicateProtocol {}

// MARK: compound operators

public extension PredicateProtocol {
    static func && (
        lhs: Self,
        rhs: Self
    ) -> CompoundPredicate<Root> {
        CompoundPredicate(type: .and, subpredicates: [lhs, rhs])
    }

    static func || (
        lhs: Self,
        rhs: Self
    ) -> CompoundPredicate<Root> {
        CompoundPredicate(type: .or, subpredicates: [lhs, rhs])
    }

    static prefix func ! (not: Self) -> CompoundPredicate<Root> {
        CompoundPredicate(type: .not, subpredicates: [not])
    }
}

// MARK: - comparison operators

public extension ConvertableValue where Self: Equatable {
    static func == <R>(
        kp: KeyPath<R, Self>,
        value: Self
    ) -> ComparisonPredicate<R> {
        ComparisonPredicate(kp, .equalTo, value)
    }

    static func != <R>(
        kp: KeyPath<R, Self>,
        value: Self
    ) -> ComparisonPredicate<R> {
        ComparisonPredicate(kp, .notEqualTo, value)
    }
}

public extension ConvertableValue where Self: Comparable {
    static func > <R>(
        kp: KeyPath<R, Self>,
        value: Self
    ) -> ComparisonPredicate<R> {
        ComparisonPredicate(kp, .greaterThan, value)
    }

    static func < <R>(
        kp: KeyPath<R, Self>,
        value: Self
    ) -> ComparisonPredicate<R> {
        ComparisonPredicate(kp, .lessThan, value)
    }

    static func <= <R>(
        kp: KeyPath<R, Self>,
        value: Self
    ) -> ComparisonPredicate<R> {
        ComparisonPredicate(kp, .lessThanOrEqualTo, value)
    }

    static func >= <R>(
        kp: KeyPath<R, Self>,
        value: Self
    ) -> ComparisonPredicate<R> {
        ComparisonPredicate(kp, .greaterThanOrEqualTo, value)
    }
}

// MARK: - internal

internal extension ComparisonPredicate {
    convenience init<Value: ConvertableValue>(
        _ keyPath: KeyPath<Root, Value>,
        _ op: NSComparisonPredicate.Operator,
        _ value: Value?
    ) {
        let attribute = Root.attribute(keyPath)
        let ex1 = NSExpression(forKeyPath: attribute.name)
        let ex2 = NSExpression(forConstantValue: value?.encode())
        self.init(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }
}
