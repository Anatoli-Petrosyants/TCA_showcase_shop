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

struct HealthKitClient {
    let requestAuthorization: (_ for: [HKQuantityTypeIdentifier]) async throws -> Bool
    let execute: (_ query: HKStatisticsCollectionQuery) async throws -> HKStatisticsCollection
}

extension HealthKitClient: DependencyKey {
    
    static let liveValue: HealthKitClient = {
        let healthStore = HKHealthStore()

        return Self (
            requestAuthorization: { identifiers in
                return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
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
                return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKStatisticsCollection, Error>) in
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

extension DependencyValues {
    var healthKitClient: HealthKitClient {
        get { self[HealthKitClient.self] }
        set { self[HealthKitClient.self] = newValue }
    }
}
