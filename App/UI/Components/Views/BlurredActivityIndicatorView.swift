//
//  BlurredActivityIndicatorView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import SwiftUI

struct BlurredActivityIndicatorView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        ZStack(alignment: .center) {
            if (!self.isShowing) {
                self.content()
            } else {
                self.content()
                    .disabled(true)

                ZStack(alignment: .center) {
                    BlurViewRepresentable(style: .systemThinMaterial)

                    VStack {
                        ActivityIndicatorViewRepresentable(style: .large)
                        Text("Please wait")
                    }
                }
                .frame(width: 140, height: 120)
                .cornerRadius(20)
            }
        }
    }
}
