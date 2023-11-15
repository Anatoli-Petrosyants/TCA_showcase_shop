//
//  QuickAction.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 15.11.23.
//

import Foundation
import UIKit

/// Enum defining the types of quick actions available.
enum QuickActionType: String {
    case favourites = "Favourites"
    case basket = "Basket"
}
/// Enum defining the possible quick actions.
enum QuickAction: Equatable {
    case favourites
    case basket

    /// Initialize a QuickAction based on the provided UIApplicationShortcutItem.
    ///
    /// - Parameter shortcutItem: The shortcut item to create the QuickAction from.
    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let type = QuickActionType(rawValue: shortcutItem.type) else {
            return nil
        }
        switch type {
        case .favourites:
            self = .favourites
        case .basket:
            self = .basket
        }
    }
}
