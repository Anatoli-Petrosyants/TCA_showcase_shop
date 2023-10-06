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
        enum ViewAction:  Equatable {
            case onNotificationTap(notification: Notification)
        }
        
        enum Delegate: Equatable {
            case didAccountNotificationTapped
        }
        
        case view(ViewAction)
        case delegate(Delegate)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(.onNotificationTap(notification)):
                if let index = state.items.firstIndex(of: notification) {
                    state.items.remove(at: index)
                }
                
                if case .account = notification.type {
                    return .send(.delegate(.didAccountNotificationTapped))
                }
                
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}


