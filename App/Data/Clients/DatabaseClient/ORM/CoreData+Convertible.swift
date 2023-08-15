//
//  CoreData+Convertible.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.07.23.
//

import Foundation

public protocol ManagedObjectConvertible {
    associatedtype ID: ConvertableValue where ID: Equatable
    static var entityName: String { get }
    static var idKeyPath: KeyPath<Self, ID> { get }
    static var attributes: Set<Attribute<Self>> { get }

    init()
}
