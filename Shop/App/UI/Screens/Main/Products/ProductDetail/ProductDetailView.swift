//
//  ProductDetailView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

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
    
    @ViewBuilder 
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                photosView
                
                VStack(alignment: .leading, spacing: 16) {
                    linkView
                    titleView
                    reviewsView
                    priceView
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
            }
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
    
    @ViewBuilder
    private var photosView: some View {
        TabView {
//            Image(systemName: "photo.on.rectangle.angled")
//                .font(.system(size: 100))
//                .tint(.black05)
            
            ForEach(store.urls, id: \.self) { url in
                WebImage(url: URL(string: url)!)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .frame(maxWidth: .infinity, idealHeight: 400)
//        .background(
//            Color(
//                uiColor: UIColor(red: 118.0 / 255.0, green: 118.0 / 255.0, blue: 128.0 / 255.0, alpha: 0.12)
//            )
//        )
        .onTapGesture {
            store.send(.view(.onViewPhotosTap))
        }
    }
    
    
    private var linkView: some View {
        ProductLinkView(
            store: self.store.scope(
                state: \.link,
                action: \.link
            )
        )
    }
    
    private var titleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(store.product.title)
                .font(.title2Bold)
            
            Text(store.product.description)
                .font(.footnote)
                .foregroundColor(.black05)
        }
    }
    
    private var priceView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.black03)
            
            Text(store.product.price.currency())
                .font(.title2Bold)
                .padding(.top, 8)

            Button("Add To Basket") {
                store.send(.view(.onAddProductsTap))
            }
            .buttonStyle(.cta)
            
            HStack {
                Spacer()
                Text(store.agreementsAttributedString)
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                Spacer()
            }
        }
    }
    
    private var reviewsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Localization.Product.detailsReviews)
                .font(.title2Bold)
            
            HStack(spacing: 4) {
                Text(String(format: "%.1f", store.product.ratingStars))
                    .font(.footnote)
                
                RatingView(rating: store.product.ratingStars)
                
                Text("(\(store.product.ratingCount))")
                    .font(.footnote)
                    .foregroundColor(.black05)
                
                Spacer()
                
                Button("show more") {
                    // viewStore.send(.present)
                }
                .foregroundColor(.blue)
                .font(.subheadline)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .padding(.vertical, 1)
                        .foregroundColor(.blue),
                    alignment: .bottom
                )
            }
            
//            ProductUsersView(
//                store: self.store.scope(
//                    state: \.users,
//                    action: \.users
//                )
//            )
        }
    }
}
