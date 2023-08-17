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
    let store: StoreOf<ProductItemReducer>
}

// MARK: - Views

extension ProductItemView: View {
    
    var body: some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black03, lineWidth: 0.5)
            )          
            .padding([.leading, .trailing, .bottom], 8)
            .onTapGesture { self.store.send(.view(.onItemTap)) }            
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(alignment: .top, spacing: 0) {
                ZStack {
                    WebImage(url: viewStore.product.imageURL)
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .padding()
                }
                .frame(maxWidth: 160)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewStore.product.title)
                        .font(.footnoteBold)
                        .padding(.top, 6)

                    Text(viewStore.product.description)
                        .lineLimit(3)
                        .font(.footnote)
                        .foregroundColor(.black05)
                    
                    HStack(spacing: 4) {
                        Text(String(format: "%.1f", viewStore.product.ratingStars))
                            .font(.footnote)
                        
                        RatingView(rating: viewStore.product.ratingStars)
                        
                        Text("(\(viewStore.product.ratingCount))")
                            .font(.footnote)
                            .foregroundColor(.black05)
                    }
                    
                    Text("\(viewStore.product.price.currency())")
                        .font(.body)
                    
                    Text("\(viewStore.product.category)")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(2)
                        .background { Color.random }
                }
                .padding(6)
                .frame(maxWidth: .infinity)
            }
        }
    }
}
