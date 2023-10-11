//
//  ProductLinkView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.06.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ProductLinkView

struct ProductLinkView {
    let store: StoreOf<ProductLinkFeature>
}

// MARK: - Views

extension ProductLinkView: View {
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Button(viewStore.text) {
                viewStore.send(.present)
            }
            .foregroundColor(.blue)
            .font(Font.headline)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .padding(.vertical, 1)
                    .foregroundColor(.blue),
                alignment: .bottom
            )
            .sheet(isPresented: viewStore.binding(
                get: \.isPresented,
                send: .dismiss
            )) {
                SFSafariViewRepresentable(url: viewStore.url)
                    .ignoresSafeArea()
            }
        }
    }
}
