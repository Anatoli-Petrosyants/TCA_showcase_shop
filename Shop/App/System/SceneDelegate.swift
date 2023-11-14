//
//  SceneDelegate.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 14.11.23.
//

import SwiftUI

/// The SceneDelegate class responsible for managing the app's scenes.
final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    /// Shared instance of QuickActionsHandler for handling quick actions.
    private let quickActionsHandler = QuickActionsHandler.shared
    
    /// Called when a shortcut item is selected to perform an action.
    ///
    /// - Parameters:
    ///   - windowScene: The window scene.
    ///   - shortcutItem: The shortcut item that was selected.
    ///   - completionHandler: The completion handler to call when the action is complete.
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        quickActionsHandler.action = QuickAction(shortcutItem: shortcutItem)
        completionHandler(true)
    }
}
