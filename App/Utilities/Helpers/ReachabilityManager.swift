//
//  ReachabilityManager.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import Reachability
import Foundation

final class ReachabilityManager {
    static let shared = ReachabilityManager()

    private let reachability: Reachability

    private var reachabilityChangedClosure: ((Bool) -> Void)?
    private var isReachabilityUpdateScheduled = false

    private init() {
        reachability = Reachability.forInternetConnection()
        
        reachability.reachableBlock = { [weak self] reachability in
            self?.scheduleReachabilityUpdate(true)
        }

        reachability.unreachableBlock = { [weak self] reachability in
            self?.scheduleReachabilityUpdate(false)
        }

        reachability.startNotifier()
    }

    deinit {
        reachability.stopNotifier()
    }

    private func scheduleReachabilityUpdate(_ isReachable: Bool) {
        guard !isReachabilityUpdateScheduled else { return }

        isReachabilityUpdateScheduled = true
                
        /// Debounce mechanism that delays the reachability updates.
        /// If an update is already scheduled, subsequent updates will be ignored until the scheduled update is processed.
        /// This helps to prevent rapid fluctuations in reachability status from triggering multiple updates.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.reachabilityChangedClosure?(isReachable)
            self?.isReachabilityUpdateScheduled = false
        }
    }

    func observeReachabilityChanges(_ closure: @escaping (Bool) -> Void) {
        reachabilityChangedClosure = closure
    }
}
