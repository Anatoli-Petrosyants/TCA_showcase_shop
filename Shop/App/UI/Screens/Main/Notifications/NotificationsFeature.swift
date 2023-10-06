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
        var items: [Notification] = [
            Notification(title: "Account", description: "Tap to add account details.", type: .account),
            Notification(title: "Checkout", description: "You have successfully checkout products.", type: .checkout)
        ]
    }
    
    enum Action: Equatable {
        case onNotificationTap(notification: Notification)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onNotificationTap(notification):
                print("onItemTap notification \(notification)")
                return .none
            }
        }
    }
}


