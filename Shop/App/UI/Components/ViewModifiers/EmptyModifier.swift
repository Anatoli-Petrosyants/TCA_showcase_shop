//
//  EmptyModifier.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 27.12.23.
//

import SwiftUI

// A view modifier that conditionally shows or hides the content based on the provided flag.
struct EmptyModifier: ViewModifier {

    // MARK: - Properties
    let isEmpty: Bool

    // MARK: - ViewModifier
    func body(content: Content) -> some View {
        Group {
            if isEmpty {
                EmptyView()
            } else {
                content
            }
        }
    }
}
