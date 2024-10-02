//
//  PurchaseDataClient.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 26.08.24.
//

import Foundation
import SwiftData
import Dependencies

extension DependencyValues {
    var purchaseDataClient: PurchaseDataClient {
        get { self[PurchaseDataClient.self] }
        set { self[PurchaseDataClient.self] = newValue }
    }
}

struct PurchaseDataClient {
    var fetchAll: @Sendable () throws -> [Purchase]
    var fetch: @Sendable (FetchDescriptor<Purchase>) throws -> [Purchase]
    var add: @Sendable (Purchase) throws -> Void
    var delete: @Sendable (Purchase) throws -> Void
    
    enum MovieError: Error {
        case add
        case delete
    }
}

extension PurchaseDataClient: DependencyKey {
    public static let liveValue = Self(
        fetchAll: {
            do {
                @Dependency(\.swiftDataClient.context) var context

                // let descriptor = FetchDescriptor<Purchase>(sortBy: [SortDescriptor(\.title)])
                let descriptor = FetchDescriptor<Purchase>(sortBy: [])
                let purchaseContext = try context()
                return try purchaseContext.fetch(descriptor)
            } catch {
                return []
            }
        },
        fetch: { descriptor in
            do {
                @Dependency(\.swiftDataClient.context) var context
                
                let purchaseContext = try context()
                return try purchaseContext.fetch(descriptor)
            } catch {
                return []
            }
        },
        add: { model in
            do {
                @Dependency(\.swiftDataClient.context) var context
                
                let purchaseContext = try context()
                purchaseContext.insert(model)
            } catch {
                throw MovieError.add
            }
        },
        delete: { model in
            do {
                @Dependency(\.swiftDataClient.context) var context
                
                let purchaseContext = try context()                
                let modelToBeDelete = model
                purchaseContext.delete(modelToBeDelete)
            } catch {
                throw MovieError.delete
            }
        }
    )
}






























//import Foundation
//import SwiftData
//import Dependencies
//
//extension DependencyValues {
//    var swiftData: PurchaseDataClient {
//        get { self[PurchaseDataClient.self] }
//        set { self[PurchaseDataClient.self] = newValue }
//    }
//}
//
//struct PurchaseDataClient {
//    var fetchAll: @Sendable () throws -> [Purchase]
//    var fetch: @Sendable (FetchDescriptor<Purchase>) throws -> [Purchase]
//    var add: @Sendable (Purchase) throws -> Void
//    var delete: @Sendable (Purchase) throws -> Void
//    
//    enum PurchaseError: Error {
//        case add
//        case delete
//    }
//}
//
//extension PurchaseDataClient: DependencyKey {
//    public static let liveValue = Self(
//        fetchAll: {
////            do {
////                @Dependency(\.databaseService.context) var context
////                let movieContext = try context()
////                
////                let descriptor = FetchDescriptor<Purchase>(sortBy: [SortDescriptor(\.title)])
////                return try movieContext.fetch(descriptor)
////            } catch {
////                return []
////            }
//            return []
//        },
//        fetch: { descriptor in
//            do {
//                @Dependency(\.swiftDataClient.context) var context
//                let movieContext = try context()
//                return try movieContext.fetch(descriptor)
//            } catch {
//                return []
//            }
//        },
//        add: { model in
//            do {
//                @Dependency(\.swiftDataClient.context) var context
//                let movieContext = try context()
//                
//                movieContext.insert(model)
//            } catch {
//                throw PurchaseError.add
//            }
//        },
//        delete: { model in
//            do {
//                @Dependency(\.swiftDataClient.context) var context
//                let movieContext = try context()
//                
//                let modelToBeDelete = model
//                movieContext.delete(modelToBeDelete)
//            } catch {
//                throw PurchaseError.delete
//            }
//        }
//    )
//}
//
//extension PurchaseDataClient: TestDependencyKey {
//    public static var previewValue = Self.noop
//    
//    public static let testValue = Self(
//        fetchAll: unimplemented("\(Self.self).fetch"),
//        fetch: unimplemented("\(Self.self).fetchDescriptor"),
//        add: unimplemented("\(Self.self).add"),
//        delete: unimplemented("\(Self.self).delete")
//    )
//    
//    static let noop = Self(
//        fetchAll: { [] },
//        fetch: { _ in [] },
//        add: { _ in },
//        delete: { _ in }
//    )
//}
