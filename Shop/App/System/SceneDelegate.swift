//
//  SceneDelegate.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 15.11.23.
//

import SwiftUI

/// The SceneDelegate class responsible for managing the app's scenes.
final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
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
        self.appDelegate.store.send(.appDelegate(.didLaunchedWithShortcutItem(shortcutItem)))        
        completionHandler(true)
    }
}
