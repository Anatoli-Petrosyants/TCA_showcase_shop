//
//  ActivityIndicator.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 01.03.23.
//

// https://stackoverflow.com/questions/56496638/activity-indicator-in-swiftui

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
