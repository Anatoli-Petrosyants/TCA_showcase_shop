//
//  LoadingView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - LoadingView

struct LoadingView {
    @Bindable var store: StoreOf<LoadingFeature>
}

// MARK: - Views

extension LoadingView: View {

    var body: some View {
        content
            .onAppear { store.send(.view(.onViewAppear)) }
    }

    @ViewBuilder private var content: some View {
        VStack(spacing: 10) {
            Text(Localization.Base.showcase).font(Font.title2)
            ProgressViewWrapper(progress: $store.progress)
        }
    }
}
