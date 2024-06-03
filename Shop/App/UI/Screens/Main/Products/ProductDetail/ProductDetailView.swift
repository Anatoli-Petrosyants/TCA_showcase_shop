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
    @Bindable var store: StoreOf<ProductDetailFeature>
}

// MARK: - Views

extension ProductDetailView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(store.product.title)
                        .font(.title1Bold)

                    Text(store.product.description)
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
                        store.send(.view(.onViewPhotosTap))
                    }
                                        
                    ProductLinkView(
                        store: self.store.scope(
                            state: \.link,
                            action: \.link
                        )
                    )
                    
                    Text(Localization.Product.detailsReviews)
                        .font(.title1Bold)
                        .padding(.top, 16)
                    
                    HStack(spacing: 4) {
                        Text(String(format: "%.1f", store.product.ratingStars))
                            .font(.footnote)
                        
                        RatingView(rating: store.product.ratingStars)
                        
                        Text("(\(store.product.ratingCount))")
                            .font(.footnote)
                            .foregroundColor(.black05)
                    }
                    
                    ProductUsersView(
                        store: self.store.scope(
                            state: \.users,
                            action: \.users
                        )
                    )
                }
                .padding()
            }
                                            
            Spacer()
            
            Button("Add To Basket \(store.product.price.currency())") {
                store.send(.view(.onAddProductsTap))
            }
            .buttonStyle(.cta)
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack {
                    Spacer()
                    
                    Button {
                        store.send(.view(.onShareTap))
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Button {
                        store.send(.view(.onFavoriteTap))
                    } label: {
                        Image(systemName: "heart")
                            .symbolVariant(store.isFavorite ? .fill : .none)
                    }
                }
            }
        }
        .sheet(
            item: $store.scope(state: \.productPhotos, action: \.productPhotos)
        ) { store in
            ProductPhotosView(store: store)
        }
        .sheet(isPresented: $store.isSharePresented) {
            ActivityViewRepresentable(
                activityItems: [
                    store.product.title,
                    store.product.category,
                    store.product.imageURL
                ]
            )
            .presentationDetents([.medium])
        }
    }
}
