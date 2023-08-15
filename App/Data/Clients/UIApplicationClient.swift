//
//  UIApplicationClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.07.23.
//

import UIKit
import Dependencies

struct UIApplicationClient {
    var open: @Sendable (URL, [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool
    var setUserInterfaceStyle: @Sendable (UIUserInterfaceStyle) async -> Void
}

extension DependencyValues {
    var applicationClient: UIApplicationClient {
        get { self[UIApplicationClient.self] }
        set { self[UIApplicationClient.self] = newValue }
    }
}

extension UIApplicationClient: DependencyKey {
    static let liveValue = Self(
        open: { @MainActor in await UIApplication.shared.open($0, options: $1) },
        setUserInterfaceStyle: { userInterfaceStyle in
            await MainActor.run {
                guard let scene = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene })
                        as? UIWindowScene else { return }
                scene.keyWindow?.overrideUserInterfaceStyle = userInterfaceStyle
            }
        }
    )
}
