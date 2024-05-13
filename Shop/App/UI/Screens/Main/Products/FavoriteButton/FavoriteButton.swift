//
//  FavoriteButton.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - FavoriteButton

struct FavoriteButton {
    let store: StoreOf<FavoriteButtonFeature>
}

// MARK: - Views

extension FavoriteButton: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        Button {
            store.send(.onTap)
        } label: {
            Image(systemName: "heart")
                .symbolVariant(store.isFavorite ? .fill : .none)
        }
    }
}
