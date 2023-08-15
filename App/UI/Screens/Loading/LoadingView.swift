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
    let store: StoreOf<Loading>
}

// MARK: - Views

extension LoadingView: View {
    
    var body: some View {
        content            
            .onAppear { ViewStore(self.store).send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 10) {
                Text(Localization.Base.showcase).font(Font.title2)
                ProgressViewWrapper(progress: viewStore.binding(\.$progress))
            }
        }
    }
}

#if DEBUG
// MARK: - Previews

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(store: Store(
            initialState: Loading.State(),
            reducer: Loading()
          )
        )
    }
}
#endif
