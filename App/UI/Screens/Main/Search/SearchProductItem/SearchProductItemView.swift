//
//  SearchProductItemView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.07.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - SearchProductItemView

struct SearchProductItemView {
    let store: StoreOf<SearchProductItemReducer>
}

// MARK: - Views

extension SearchProductItemView: View {
    
    var body: some View {
        content
            .onTapGesture { ViewStore(self.store).send(.view(.onItemTap)) }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black03, lineWidth: 0.5)
            )
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 6) {
                ZStack {
                    WebImage(url: viewStore.product.imageURL)
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .padding()
                }
                
                Text(viewStore.product.title)
                    .font(.footnote)
                
                HStack {
                    Text("\(viewStore.product.price.currency())")
                        .font(.body)
                    
                    Spacer()
                    
                    SearchFavoriteButton(
                        store: self.store.scope(
                            state: \.favorite,
                            action: SearchProductItemReducer.Action.favorite
                        )
                    )
                }
            }
            .padding()
        }
    }
}
