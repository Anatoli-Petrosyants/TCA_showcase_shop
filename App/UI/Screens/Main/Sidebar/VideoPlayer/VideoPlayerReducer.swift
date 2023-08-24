//
//  VideoPlayerReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.08.23.
//

import SwiftUI
import ComposableArchitecture
import AVKit

struct VideoPlayerReducer: Reducer {
    
    struct State: Equatable, Hashable {
        let url: URL

        var player: AVPlayer = {
            AVPlayer(url: Constant.videoURL)
        }()
    }
    
    enum Action: Equatable {
        case onViewAppear
        case onCloseTap
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                state.player.play()
                return .none
                
            case .onCloseTap:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
