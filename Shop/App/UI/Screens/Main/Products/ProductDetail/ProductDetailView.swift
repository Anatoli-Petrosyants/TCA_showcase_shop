//
//  ProductDetailView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ProductDetailView

struct ProductDetailView {
    let store: StoreOf<ProductDetailFeature>
}

// MARK: - Views

extension ProductDetailView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(viewStore.product.title)
                            .font(.title1Bold)

                        Text(viewStore.product.description)
                            .font(.body)
                            .foregroundColor(.black05)
                        
                        HStack(spacing: 0) {
                            Text(Localization.Product.detailsViewPhotos)
                                .foregroundColor(.black)
                                .font(.bodyBold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .tint(.black05)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black03, lineWidth: 0.5)
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewStore.send(.view(.onViewPhotosTap))
                        }
                        
                        ProductLinkView(
                            store: self.store.scope(
                                state: \.link,
                                action: ProductDetailFeature.Action.link
                            )
                        )
                        
                        Text(Localization.Product.detailsReviews)
                            .font(.title1Bold)
                            .padding(.top, 16)
                        
                        HStack(spacing: 4) {
                            Text(String(format: "%.1f", viewStore.product.ratingStars))
                                .font(.footnote)
                            
                            RatingView(rating: viewStore.product.ratingStars)
                            
                            Text("(\(viewStore.product.ratingCount))")
                                .font(.footnote)
                                .foregroundColor(.black05)
                        }

                        ProductUsersView(
                            store: self.store.scope(
                                state: \.users,
                                action: ProductDetailFeature.Action.users
                            )
                        )
                    }
                    .padding()
                }
                                                
                Spacer()
                
                Button("Add To Basket \(viewStore.product.price.currency())") {
                    viewStore.send(.view(.onAddProductsTap))
                }
                .buttonStyle(.cta)
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.view(.onFavoriteTap))                    
                    } label: {
                        Image(systemName: "heart")
                            .symbolVariant(viewStore.isFavorite ? .fill : .none)
                    }
                }
            }
            .sheet(
                store: store.scope(state: \.$productPhotos, action: { .productPhotos($0) }),
                content: ProductPhotosView.init(store:)
            )
        }
    }
}
