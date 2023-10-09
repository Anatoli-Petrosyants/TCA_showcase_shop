//
//  Notification.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 05.10.23.
//

import Foundation

struct Notification: Equatable, Identifiable, Hashable {    
    enum NotificationType: CaseIterable {
        case account, checkout
    }
    
    let id = UUID()
    let title: String
    let description: String
    let type: NotificationType
}

extension Notification {
    static var checkout = Notification(title: "Checkout",
                                       description: "You have successfully checkout products.",
                                       type: .checkout)
    
    static var account = Notification(title: "Account",
                                      description: "Tap to add account details.",
                                      type: .account)
}
