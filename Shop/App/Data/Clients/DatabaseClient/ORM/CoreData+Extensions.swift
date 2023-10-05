//
//  CoreData+Extensions.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.07.23.
//

import CoreData
import Foundation

public extension NSPersistentContainer {
    func schedule<T>(
        _ action: @Sendable @escaping (NSManagedObjectContext) throws -> T
    ) async throws -> T {
        try Task.checkCancellation()

        let context = newBackgroundContext()

        if #available(iOS 15.0, macOS 12.0, *) {
            return try await context.perform(schedule: .immediate) {
                try context.execute(action)
            }
        } else {
            return try await withUnsafeThrowingContinuation { continuation in
                continuation.resume(
                    with: .init { try context.execute(action) }
                )
            }
        }
    }
}

public extension NSManagedObjectContext {
    @discardableResult
    func insert(entity name: String) -> NSManagedObject? {
        persistentStoreCoordinator
            .flatMap { $0.managedObjectModel.entitiesByName[name] }
            .flatMap { .init(entity: $0, insertInto: self) }
    }

    @discardableResult
    func fetch(
        _ request: CoreDataRequest<some ManagedObjectConvertible>
    ) throws -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = request.makeFetchRequest()
        return try fetch(fetchRequest)
    }

    @_optimize(none)
    @discardableResult
    func fetchOne(
        _ request: CoreDataRequest<some ManagedObjectConvertible>
    ) throws -> NSManagedObject? {
        try fetch(request.limit(1)).first
    }

    func delete(
        _ request: CoreDataRequest<some ManagedObjectConvertible>
    ) throws {
        let items = try fetch(request)

        for item in items {
            delete(item)
        }
    }
}

extension NSManagedObjectContext {
    func execute<T>(
        _ action: @Sendable @escaping (NSManagedObjectContext) throws -> T
    ) throws -> T {
        defer {
            self.reset()
        }

        let value = try action(self)

        if hasChanges {
            try save()
        }

        return value
    }
}

public extension NSManagedObject {
    func decode<T: ManagedObjectConvertible>() throws -> T {
        try T(from: self)
    }

    func update(
        _ item: some ManagedObjectConvertible
    ) throws {
        try item.encodeAttributes(to: self)
    }

    func update<T: ManagedObjectConvertible, V: ConvertableValue>(
        _ keyPath: WritableKeyPath<T, V>,
        _ value: V
    ) throws {
        self[primitiveValue: T.attribute(keyPath).name] = value.encode()
    }

    func update<T: ManagedObjectConvertible, V: ConvertableValue>(
        _ keyPath: WritableKeyPath<T, V?>,
        _ value: V?
    ) throws {
        self[primitiveValue: T.attribute(keyPath).name] = value?.encode()
    }
}

extension NSManagedObject {
    subscript(primitiveValue forKey: String) -> Any? {
        get {
            defer { didAccessValue(forKey: forKey) }
            willAccessValue(forKey: forKey)
            return primitiveValue(forKey: forKey)
        }
        set(newValue) {
            defer { didChangeValue(forKey: forKey) }
            willChangeValue(forKey: forKey)
            setPrimitiveValue(newValue, forKey: forKey)
        }
    }
}
