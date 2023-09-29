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
    let store: StoreOf<FavoriteButtonReducer>
}

// MARK: - Views

extension FavoriteButton: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.onTap)
            } label: {
                Image(systemName: "heart")
                    .symbolVariant(viewStore.isFavorite ? .fill : .none)
            }
        }
    }
}
