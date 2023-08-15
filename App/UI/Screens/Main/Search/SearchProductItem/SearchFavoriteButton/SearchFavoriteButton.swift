//
//  SearchFavoriteButton.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SearchFavoriteButton

struct SearchFavoriteButton {
    let store: StoreOf<SearchFavoriteButtonReducer>
}

// MARK: - Views

extension SearchFavoriteButton: View {
    
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
