//
//  ReachabilityClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import Dependencies
import Foundation

struct ReachabilityClient {
    enum Connectivity {
        case online
        case offline
    }

    var start: @Sendable () -> AsyncStream<Connectivity>
}

extension DependencyValues {
    var reachability: ReachabilityClient {
        get { self[ReachabilityClient.self] }
        set { self[ReachabilityClient.self] = newValue }
    }
}

extension ReachabilityClient: DependencyKey {
    static let liveValue: Self = {
        return Self(
            start: {
                AsyncStream { continuation in
                    ReachabilityManager.shared.observeReachabilityChanges { isReachable in
                        continuation.yield(isReachable ? .online : .offline)
                    }
                }
            }
        )
    }()
}
