//
//  HealthClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.07.23.
//

// https://gist.github.com/converted2mac/a7e3159dcec59809116b69b64f6bbe5b

import HealthKit
import SwiftUI
import ComposableArchitecture
import Dependencies

/// A client for interacting with HealthKit.
struct HealthKitClient {
    /// Requests authorization to access HealthKit data.
    /// - Parameter for: An array of HKQuantityTypeIdentifier for which authorization is requested.
    /// - Returns: A boolean indicating if the authorization was successful.
    let requestAuthorization: (_ for: [HKQuantityTypeIdentifier]) async throws -> Bool
    
    /// Executes a HealthKit statistics collection query.
    /// - Parameter query: The query to be executed.
    /// - Returns: An HKStatisticsCollection containing the query results.
    let execute: (_ query: HKStatisticsCollectionQuery) async throws -> HKStatisticsCollection
}

extension DependencyValues {
    /// Accessor for the HealthKitClient in the dependency values.
    var healthKitClient: HealthKitClient {
        get { self[HealthKitClient.self] }
        set { self[HealthKitClient.self] = newValue }
    }
}

extension HealthKitClient: DependencyKey {
    /// A live implementation of HealthKitClient.
    static let liveValue: HealthKitClient = {
        let healthStore = HKHealthStore()

        return Self(
            requestAuthorization: { identifiers in
                return try await withCheckedThrowingContinuation { continuation in
                    let types = Set(identifiers.compactMap { HKQuantityType.quantityType(forIdentifier: $0) })
                    healthStore.requestAuthorization(toShare: [], read: types) { success, error in
                        if let hasError = error {
                            return continuation.resume(throwing: hasError)
                        }
                        return continuation.resume(with: .success(success))
                    }
                }
            },
            execute: { query in
                return try await withCheckedThrowingContinuation { continuation in
                    query.initialResultsHandler = { query, statsCollection, error in
                        if let hasError = error {
                            return continuation.resume(throwing: hasError)
                        }
                        
                        if let hasStatsCollection = statsCollection {
                            return continuation.resume(with: .success(hasStatsCollection))
                        }
                    }
                    
                    healthStore.execute(query)
                }
            }
        )
    }()
}
