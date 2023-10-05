//
//  UIApplicationClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.07.23.
//

import UIKit
import Dependencies

/// A client for interacting with UIApplication, including opening URLs and setting user interface style.
struct UIApplicationClient {
    /// A method to asynchronously open a URL with specified options.
    var open: @Sendable (URL, [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool
    /// A method to set the user interface style of the app.
    var setUserInterfaceStyle: @Sendable (UIUserInterfaceStyle) async -> Void
}

extension DependencyValues {
    /// Accessor for the UIApplicationClient in the dependency values.
    var applicationClient: UIApplicationClient {
        get { self[UIApplicationClient.self] }
        set { self[UIApplicationClient.self] = newValue }
    }
}

extension UIApplicationClient: DependencyKey {
    /// A live implementation of UIApplicationClient.
    static let liveValue = Self(
        open: {
            // Open the URL asynchronously using UIApplication's open method.
            @MainActor in await UIApplication.shared.open($0, options: $1)
        },
        setUserInterfaceStyle: { userInterfaceStyle in
            // Set the user interface style of the app's key window.
            await MainActor.run {
                guard let scene = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene })
                        as? UIWindowScene else { return }
                scene.keyWindow?.overrideUserInterfaceStyle = userInterfaceStyle
            }
        }
    )
}
