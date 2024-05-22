//
//  VideoPlayerView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.08.23.
//

import SwiftUI
import ComposableArchitecture
import AVKit

// MARK: - VideoPlayerView

struct VideoPlayerView {
    let store: StoreOf<VideoPlayerFeature>
}

// MARK: - Views

extension VideoPlayerView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        NavigationStack {
            VideoPlayer(player: store.player)
                .ignoresSafeArea()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(Localization.Base.close) {
                            store.send(.onCloseTap)
                        }
                        .tint(.black)
                    }
                }
        }
    }
}
