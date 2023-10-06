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
