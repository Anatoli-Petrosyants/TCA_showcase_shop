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
            Notification(title: "Account", description: "Tap to add account details.", type: .account)            
        ]
        
        @PresentationState var alert: AlertState<Action.AlertAction>?
    }
    
    enum Action: Equatable {
        enum ViewAction:  Equatable {
            case onNotificationTap(notification: Notification)
        }
        
        enum Delegate: Equatable {
            case didAccountNotificationTapped
        }
        
        enum InternalAction: Equatable {
            case deleteNotification(Notification)
        }
        
        enum AlertAction: Equatable {
            case viewNotification(Notification)
        }
        
        case view(ViewAction)
        case delegate(Delegate)
        case `internal`(InternalAction)
        case alert(PresentationAction<AlertAction>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(.onNotificationTap(notification)):                
                state.alert = AlertState(title: {
                    TextState(notification.title)
                } ,
                                         actions: {
                    ButtonState(action: .viewNotification(notification)) {
                        TextState("View")
                    }
                    
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } ,
                                         message: {
                    TextState(notification.description)
                })
                
                return .none
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .deleteNotification(notification):
                    if let index = state.items.firstIndex(of: notification) {
                        state.items.remove(at: index)
                    }

                    if case .account = notification.type {
                        return .send(.delegate(.didAccountNotificationTapped))
                    }
                    return .none
                }
                
            // alert actions
            case let .alert(.presented(.viewNotification(notification))):
                return .send(.internal(.deleteNotification(notification)))
                
            case .delegate, .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}


