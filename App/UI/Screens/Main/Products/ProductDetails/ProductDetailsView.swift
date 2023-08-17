//
//  ProductDetailsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ProductDetailsView

struct ProductDetailsView {
    let store: StoreOf<ProductDetails>
}

// MARK: - Views

extension ProductDetailsView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack() {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(viewStore.product.title)
                            .font(.title1Bold)

                        Text(viewStore.product.description)
                            .font(.body)
                            .foregroundColor(.black05)
                        
                        HStack(spacing: 0) {
                            Text("View Photos")
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
                                action: ProductDetails.Action.link
                            )
                        )
                        
                        Text("Reviews")
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
                                action: ProductDetails.Action.users
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
            .sheet(
                store: store.scope(state: \.$productPhotos, action: ProductDetails.Action.productPhotos),
                content: ProductPhotosView.init(store:)
            )
        }
    }
}
