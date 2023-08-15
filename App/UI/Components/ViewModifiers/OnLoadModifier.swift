//
//  OnLoadModifier.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.06.23.
//

import SwiftUI

struct OnLoadModifier: ViewModifier {

    @State private var hasLoaded = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasLoaded {
                    action()
                    hasLoaded = true
                }
            }
    }
}

extension View {
    func onLoad(perform action: @escaping () -> Void) -> some View {
        self.modifier(OnLoadModifier(action: action))
    }
}
