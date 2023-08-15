//
//  BlurViewRepresentable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import SwiftUI

struct BlurViewRepresentable: UIViewRepresentable {

    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurViewRepresentable>) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurViewRepresentable>) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
