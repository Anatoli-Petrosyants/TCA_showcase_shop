//
//  ReachabilityClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import Dependencies
import Foundation

/// A client for monitoring reachability status.
struct ReachabilityClient {
    /// The possible connectivity states.
    enum Connectivity {
        case online
        case offline
    }

    /// A method to start observing reachability changes.
    var start: @Sendable () -> AsyncStream<Connectivity>
}

extension DependencyValues {
    /// Accessor for the ReachabilityClient in the dependency values.
    var reachability: ReachabilityClient {
        get { self[ReachabilityClient.self] }
        set { self[ReachabilityClient.self] = newValue }
    }
}

extension ReachabilityClient: DependencyKey {
    /// A live implementation of ReachabilityClient.
    static let liveValue: Self = {
        return Self(
            start: {
                AsyncStream { continuation in
                    // Observe reachability changes using the shared ReachabilityManager.
                    ReachabilityManager.shared.observeReachabilityChanges { isReachable in
                        continuation.yield(isReachable ? .online : .offline)
                    }
                }
            }
        )
    }()
}

