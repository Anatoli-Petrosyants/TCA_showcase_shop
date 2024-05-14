//
//  ProductItemView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.06.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - ProductItemView

struct ProductItemView {
    let store: StoreOf<ProductItemFeature>
}

// MARK: - Views

extension ProductItemView: View {
    
    var body: some View {
        CardView {
            content
        }
        .onTapGesture { self.store.send(.view(.onItemTap)) }
    }
    
    @ViewBuilder private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                WebImage(url: store.product.imageURL)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .padding()
            }
            
            Text(store.product.title)
                .font(.footnote)
            
            HStack(spacing: 4) {
                Text(String(format: "%.1f", store.product.ratingStars))
                    .font(.footnote)
                
                RatingView(rating: store.product.ratingStars)
                
                Text("(\(store.product.ratingCount))")
                    .font(.footnote)
                    .foregroundColor(.black05)
            }
            
            Text("\(store.product.price.currency())")
                .font(.body)
            
            HStack {
                Text("\(store.product.category)")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(2)
                
                Spacer()
                
                FavoriteButton(
                    store: self.store.scope(
                        state: \.favorite,
                        action: \.favorite
                    )
                )
            }
        }
        .padding()
    }
}
