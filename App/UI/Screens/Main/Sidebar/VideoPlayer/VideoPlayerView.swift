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
    let store: StoreOf<VideoPlayerReducer>
}

// MARK: - Views

extension VideoPlayerView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VideoPlayer(player: AVPlayer(url: Constant.videoURL))
                .frame(height: 400)
        }
    }
}
