//
//  ReachabilityManager.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import Reachability
import Foundation

// A manager class to handle network reachability status.
final class ReachabilityManager {
    // Singleton instance of the reachability manager.
    static let shared = ReachabilityManager()

    private let reachability: Reachability

    private var reachabilityChangedClosure: ((Bool) -> Void)?
    private var isReachabilityUpdateScheduled = false

    private init() {
        // Initialize the Reachability instance.
        reachability = Reachability.forInternetConnection()
        
        // Define the closure to be called when reachability changes to reachable.
        reachability.reachableBlock = { [weak self] reachability in
            self?.scheduleReachabilityUpdate(true)
        }

        // Define the closure to be called when reachability changes to unreachable.
        reachability.unreachableBlock = { [weak self] reachability in
            self?.scheduleReachabilityUpdate(false)
        }

        // Start monitoring network reachability.
        reachability.startNotifier()
    }

    deinit {
        // Stop monitoring network reachability when the manager is deallocated.
        reachability.stopNotifier()
    }

    // Schedule a delayed reachability update to prevent rapid changes triggering multiple updates.
    private func scheduleReachabilityUpdate(_ isReachable: Bool) {
        guard !isReachabilityUpdateScheduled else { return }

        isReachabilityUpdateScheduled = true
                
        // Debounce mechanism: Update reachability status after a delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.reachabilityChangedClosure?(isReachable)
            self?.isReachabilityUpdateScheduled = false
        }
    }

    // Observe reachability changes with a closure callback.
    func observeReachabilityChanges(_ closure: @escaping (Bool) -> Void) {
        reachabilityChangedClosure = closure
    }
}

