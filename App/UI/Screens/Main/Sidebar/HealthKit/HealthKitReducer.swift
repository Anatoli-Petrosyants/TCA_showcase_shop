//
//  HealthKitReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies
import SwiftUINavigation
import HealthKit

struct HealthKitReducer: ReducerProtocol {
    
    struct Step: Identifiable, Equatable {
        let id = UUID()
        let value: Int
        let date: Date
    }
    
    struct Distance: Identifiable, Equatable {
        let id = UUID()
        let value: Measurement<UnitLength>
        let date: Date
    }
    
    struct State: Equatable {
        var isActivityIndicatorVisible = false
        var steps: [Step] = []
        var distances: [Distance] = []
        @PresentationState var alert: AlertState<Never>?
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onViewAppear
        }
        
        enum InternalAction: Equatable {
            case authorizationError(Error)
            case stepsResponse(TaskResult<HKStatisticsCollection>)
            case distanceResponse(TaskResult<HKStatisticsCollection>)
            
            static func == (lhs: HealthKitReducer.Action.InternalAction,
                            rhs: HealthKitReducer.Action.InternalAction) -> Bool {
                return true
            }
        }
        
        case view(ViewAction)
        case `internal`(InternalAction)
        case alert(PresentationAction<Never>)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.healthKitClient) var healthKitClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            // view actions
            case .view(.onViewAppear):
                state.isActivityIndicatorVisible = true
                return .run { send in
                    do {
                        try await self.clock.sleep(for: .milliseconds(300))
                        let authorized = try await self.healthKitClient.requestAuthorization([.stepCount, .distanceWalkingRunning])
 
                        if authorized {
                            await send(
                                .internal(
                                    .stepsResponse(
                                        await TaskResult {
                                            try await self.healthKitClient.execute(query(for: .stepCount))
                                        }
                                    )
                                )
                            )
                            
                            await send(
                                .internal(
                                    .distanceResponse(
                                        await TaskResult {
                                            try await self.healthKitClient.execute(query(for: .distanceWalkingRunning))
                                        }
                                    )
                                )
                            )
                        }
                    } catch let error {
                        await send(.internal(.authorizationError(error)))
                    }
                }
                
            // internal actions
            case let .internal(.authorizationError(error)):
                state.isActivityIndicatorVisible = false
                state.alert = AlertState { TextState(error.localizedDescription) }
                return .none
                
            case let .internal(.stepsResponse(.success(collection))):
                state.isActivityIndicatorVisible = false
                var steps: [Step] = []
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
                let endDate = Date()
                collection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
                    if let sum = stats.sumQuantity() {
                        let value = sum.doubleValue(for: .count())
                        let step = Step(value: Int(value), date: stats.startDate)
                        steps.append(step)
                    }
                }
                state.steps.append(contentsOf: steps)
                return .none
                
            case let .internal(.distanceResponse(.success(collection))):
                state.isActivityIndicatorVisible = false
                var distances: [Distance] = []
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
                let endDate = Date()
                collection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
                    if let sum = stats.sumQuantity() {
                        let value = sum.doubleValue(for: .meter())
                        let measurement = Measurement(value: value, unit: UnitLength.meters)
                        let distance = Distance(value: measurement, date: stats.startDate)
                        distances.append(distance)
                    }
                }
                state.distances.append(contentsOf: distances)
                return .none
                
            case let .internal(.stepsResponse(.failure(error))),
                 let .internal(.distanceResponse(.failure(error))):
                state.isActivityIndicatorVisible = false
                state.alert = AlertState { TextState(error.localizedDescription) }
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}

// MARK: HealthKitReducer helpers

private extension HealthKitReducer {
    
    func query(for identifier: HKQuantityTypeIdentifier) -> HKStatisticsCollectionQuery {
        let type = HKQuantityType.quantityType(forIdentifier: identifier)!
        let anchorDate = Calendar.current.startOfDay(for: Date())
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: type,
                                               quantitySamplePredicate: nil,
                                               options: .cumulativeSum,
                                               anchorDate: anchorDate,
                                               intervalComponents: interval)
        return query
    }
}
