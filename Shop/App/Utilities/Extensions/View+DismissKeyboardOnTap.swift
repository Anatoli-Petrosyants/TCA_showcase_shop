//
//  View+DismissKeyboardOnTap.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 15.08.23.
//

import SwiftUI

public extension View {

    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

public struct DismissKeyboardOnTap: ViewModifier {

    public func body(content: Content) -> some View {
        return content.gesture(tapGesture)
    }

    private var tapGesture: some Gesture {
        TapGesture().onEnded(
            endEditing
        )
    }

    private func endEditing() {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap({ $0 })
            .first?.windows
            .filter { $0.isKeyWindow }
            .first?.endEditing(true)
    }
}
