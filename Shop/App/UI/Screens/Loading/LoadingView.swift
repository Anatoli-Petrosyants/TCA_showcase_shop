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
    let store: StoreOf<LoadingFeature>
    
    struct ViewState: Equatable {
        @BindingViewState var progress: Double
    }
}

// MARK: - Views

extension LoadingView: View {

    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
            // .onDisappear { self.store.send(.view(.onDisappear)) }
    }

    @ViewBuilder private var content: some View {
//        WithViewStore(self.store, observe: ViewState.init) { viewStore in
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
//        WithViewStore(self.store, observe: \.progress) { viewStore in
//        WithViewStore(self.store, observe: { $0 }, send: { .view($0) }) { viewStore in
//        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
            VStack(spacing: 10) {
                Text(Localization.Base.showcase).font(Font.title2)
                ProgressViewWrapper(progress: viewStore.$progress)
            }
        }
    }
}

// MARK: BindingViewStore

extension BindingViewStore<LoadingFeature.State> {
    var view: LoadingView.ViewState {
        LoadingView.ViewState(progress: self.$progress)
    }
}
