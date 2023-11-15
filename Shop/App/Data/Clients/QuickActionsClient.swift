//
//  QuickActionsClient.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 14.11.23.
//

import Foundation
import UIKit
import Dependencies

/// Enum defining the types of quick actions available.
enum QuickActionType: String {
    case favourites = "Favourites"
    // Add new actions here in future
}

/// Enum defining the possible quick actions.
enum QuickAction: Equatable {
    case favourites

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
        }
    }
}

struct QuickActionsClient {
    var save: @Sendable (UIApplicationShortcutItem) -> Void
    var get: () -> QuickAction?
}

/// Extension to provide access to QuickActionsClient in the dependency values.
extension DependencyValues {
    var quickActionsClient: QuickActionsClient {
        get { self[QuickActionsClient.self] }
        set { self[QuickActionsClient.self] = newValue }
    }
}

/// Extension to make QuickActionsClient a DependencyKey.
extension QuickActionsClient: DependencyKey {
    /// The live implementation of QuickActionsClient.
    static let liveValue: Self = {

        return Self(
            save: { shortcutItem in
                QuickActionsHandler.shared.action = QuickAction(shortcutItem: shortcutItem)
            },
            get: {
                return QuickActionsHandler.shared.action
            }
        )
    }()
}

/// Singleton class responsible for handling quick actions.
class QuickActionsHandler: ObservableObject {
    /// Shared instance of QuickActionsHandler.
    static let shared = QuickActionsHandler()

    /// Property of the selected quick action.
    var action: QuickAction?
}
