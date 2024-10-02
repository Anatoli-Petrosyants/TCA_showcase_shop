//
//  SwiftDataClient.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 26.08.24.
//

import Foundation
import SwiftData
import Dependencies

extension DependencyValues {
    var swiftDataClient: SwiftDataClient {
        get { self[SwiftDataClient.self] }
        set { self[SwiftDataClient.self] = newValue }
    }
}

fileprivate let appContext: ModelContext = {
    do {
        let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
        let config = ModelConfiguration(url: url)
        let container = try ModelContainer(for: Purchase.self, configurations: config)
        return ModelContext(container)
    } catch {
        fatalError("Failed to create container.")
    }
}()

struct SwiftDataClient {
    var context: () throws -> ModelContext
}

extension SwiftDataClient: DependencyKey {
    public static let liveValue = Self(
        context: { appContext }
    )
}

extension SwiftDataClient: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        context: unimplemented("\(Self.self).context")
    )
    
    static let noop = Self(
        context: unimplemented("\(Self.self).context")
    )
}































































//struct SwiftDataClient {
//    var context: @Sendable () -> ModelContext
//}
//
//extension DependencyValues {    
//    var swiftDataClient: SwiftDataClient {
//        get { self[SwiftDataClient.self] }
//        set { self[SwiftDataClient.self] = newValue }
//    }
//}
//
//extension SwiftDataClient: DependencyKey {
//    /// A live implementation of SwiftDataClient.
//    static let liveValue: SwiftDataClient = {
//        let appContext: ModelContext = {
//            do {
//                let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
//                let config = ModelConfiguration(url: url)
//                
//                let container = try ModelContainer(for: Purchase.self, configurations: config)
//                return ModelContext(container)
//            } catch {
//                fatalError("Failed to create container.")
//            }
//        }()
//        
//        return Self(
//            context: { appContext }
//        )
//    }()
//}




//import Foundation
//import SwiftData
//import Dependencies
//
//extension DependencyValues {    
//    var swiftDataClient: SwiftDataClient {
//        get { self[SwiftDataClient.self] }
//        set { self[SwiftDataClient.self] = newValue }
//    }
//}
//
//fileprivate let appContext: ModelContext = {
//    do {
//        let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
//        let config = ModelConfiguration(url: url)
//        
//        let container = try ModelContainer(for: Purchase.self, configurations: config)
//        return ModelContext(container)
//    } catch {
//        fatalError("Failed to create container.")
//    }
//}()
//
//fileprivate let liveContainer: ModelContainer = {
//    do {
//        let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
//        let config = ModelConfiguration(url: url)
//        
//        return try ModelContainer(for: Purchase.self, configurations: config)
//    } catch {
//        fatalError("Failed to create live container.")
//    }
//}()
//
//struct SwiftDataClient {
//    var context: @Sendable () -> ModelContext
//    var container: @Sendable () -> ModelContainer
//}
//
//extension SwiftDataClient: DependencyKey {
//    public static let liveValue = Self(
//        context: { appContext },
//        container: { liveContainer }
//    )
//}
//
//extension SwiftDataClient: TestDependencyKey {
//    public static var previewValue = Self.noop
//    
//    public static let testValue = Self(
//        context: unimplemented("\(Self.self).context"), 
//        container: unimplemented("\(Self.self).container")
//    )
//    
//    static let noop = Self(
//        context: unimplemented("\(Self.self).context"),
//        container: unimplemented("\(Self.self).container")
//    )
//}
