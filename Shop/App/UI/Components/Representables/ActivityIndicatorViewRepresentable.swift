//
//  ActivityIndicatorViewRepresentable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import SwiftUI

struct ActivityIndicatorViewRepresentable: UIViewRepresentable {

    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorViewRepresentable>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.startAnimating()
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorViewRepresentable>) {
        uiView.style = style
        uiView.startAnimating()
    }
}
