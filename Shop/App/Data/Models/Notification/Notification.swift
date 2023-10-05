//
//  Notification.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 05.10.23.
//

import Foundation

struct Notification: Equatable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
}
