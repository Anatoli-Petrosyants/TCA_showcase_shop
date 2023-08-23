//
//  AVPlayerViewRepresentable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 23.08.23.
//

import SwiftUI

struct AVPlayerViewRepresentable: UIViewControllerRepresentable {
    let videoURL: URL?
    let isPlaying: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: videoURL)
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if isPlaying {
            uiViewController.player?.play()
        } else {
            uiViewController.player?.pause()
        }
    }
}

