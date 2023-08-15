//
//  SFSafariViewRepresentable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

/// https://github.com/cockscomb/SafariServicesUI/blob/main/Sources/SafariServicesUI/SafariView.swift

import SwiftUI
import SafariServices

/// SFSafariViewController Wrapper
struct SFSafariViewRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = SFSafariViewController
    typealias Configuration = SFSafariViewController.Configuration

    private let url: URL
    private let configuration: Configuration?

    init(url: URL, configuration: Configuration? = nil) {
        self.url = url
        self.configuration = configuration
    }

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController: SFSafariViewController
        if let configuration {
            safariViewController = SFSafariViewController(url: url, configuration: configuration)
        } else {
            safariViewController = SFSafariViewController(url: url)
        }
        return safariViewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

    }
}
