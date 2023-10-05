//
//  NotificationsFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 05.10.23.
//

import SwiftUI
import ComposableArchitecture

struct NotificationsFeature: Reducer {
    
    struct State: Equatable {
        var notifications: [Notification] = []
    }
    
    enum Action: Equatable {
        case onViewAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none
            }
        }
    }
}


