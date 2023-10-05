//
//  CoreDataClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.06.23.
//

import Foundation
import CoreData
import ComposableArchitecture
import Dependencies

// MARK: - DatabaseClientProtocol

protocol DatabaseClientProtocol {
    // Insert
    func insert<T: ManagedObjectConvertible>(_ item: T) async throws

    // Update
    @discardableResult
    func update<T: ManagedObjectConvertible, V: ConvertableValue>(
        _ id: T.ID,
        _ keyPath: WritableKeyPath<T, V>,
        _ value: V
    ) async throws -> Bool

    @discardableResult
    func update<T: ManagedObjectConvertible, V: ConvertableValue>(
        _ id: T.ID,
        _ keyPath: WritableKeyPath<T, V?>,
        _ value: V?
    ) async throws -> Bool

    func delete<T: ManagedObjectConvertible>(_ item: T) async throws
    func fetch<T: ManagedObjectConvertible>(_ request: CoreDataRequest<T>) async throws -> [T]
    func observe<T: ManagedObjectConvertible>(_ request: CoreDataRequest<T>) -> AsyncStream<[T]>
}

// MARK: - DatabaseClientKey

// An enum representing the database client as a dependency key.
enum DatabaseClientKey: DependencyKey {
    public static let liveValue = DatabaseClient.shared as DatabaseClientProtocol
}

extension DependencyValues {
    // A property to access the database client dependency.
    var databaseClient: DatabaseClientProtocol {
        get { self[DatabaseClientKey.self] }
        set { self[DatabaseClientKey.self] = newValue }
    }
}

// The main class that handles database operations.
final class DatabaseClient: DatabaseClientProtocol, @unchecked Sendable {
    // Singleton instance of the database client.
    static let shared = DatabaseClient()
    private let persistentContainer: NSPersistentContainer

    private init() {
        let bundle = Bundle(for: DatabaseClient.self)
        
        guard let databaseURL = bundle.url(forResource: "Showcase_Database", withExtension: "momd") else {
            fatalError("Failed to find database URL")
        }

        let database = databaseURL.deletingPathExtension().lastPathComponent
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: databaseURL) else {
            fatalError("Failed to create model from file: \(databaseURL)")
        }
        
        self.persistentContainer = NSPersistentContainer(name: database, managedObjectModel: managedObjectModel)
        persistentContainer.loadPersistentStores { [unowned self] description, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
            
            description.shouldMigrateStoreAutomatically = false
            description.shouldInferMappingModelAutomatically = true
            persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }

    func insert<T: ManagedObjectConvertible>(
        _ item: T
    ) async throws {
        try await persistentContainer.schedule { ctx in
            let object: NSManagedObject?

            if let objectFound = try ctx.fetchOne(T.all.where(T.idKeyPath == item[keyPath: T.idKeyPath])) {
                object = objectFound
            } else {
                object = ctx.insert(entity: T.entityName)
            }

            try object?.update(item)
        }
    }

    func update<T: ManagedObjectConvertible, V: ConvertableValue>(
        _ id: T.ID,
        _ keyPath: WritableKeyPath<T, V?>,
        _ value: V?
    ) async throws -> Bool {
        try await persistentContainer.schedule { ctx in
            if let managed = try ctx.fetchOne(T.all.where(T.idKeyPath == id)) {
                try managed.update(keyPath, value)
                return true
            } else {
                return false
            }
        }
    }

    func update<T: ManagedObjectConvertible, V: ConvertableValue>(
        _ id: T.ID,
        _ keyPath: WritableKeyPath<T, V>,
        _ value: V
    ) async throws -> Bool {
        try await persistentContainer.schedule { ctx in
            if let managed = try ctx.fetchOne(T.all.where(T.idKeyPath == id)) {
                try managed.update(keyPath, value)
                return true
            } else {
                return false
            }
        }
    }

    func delete<T: ManagedObjectConvertible>(
        _ item: T
    ) async throws {
        try await persistentContainer.schedule { ctx in
            try ctx.delete(T.all.where(T.idKeyPath == item[keyPath: T.idKeyPath]))
        }
    }

    func fetch<T: ManagedObjectConvertible>(
        _ request: CoreDataRequest<T>
    ) async throws -> [T] {
        try await persistentContainer.schedule { ctx in
            try ctx.fetch(request).map { try $0.decode() }
        }
    }

    func observe<T: ManagedObjectConvertible>(
        _ request: CoreDataRequest<T>
    ) -> AsyncStream<[T]> {
        .init { continuation in
            Task.detached { [unowned self] in
                let values = try? await self.fetch(request)
                continuation.yield(values ?? [])

                let observe = NotificationCenter.default.observeNotifications(
                    from: NSManagedObjectContext.didSaveObjectsNotification
                )

                for await _ in observe {
                    let values = try? await self.fetch(request)
                    continuation.yield(values ?? [])
                }
            }
        }
    }
}
