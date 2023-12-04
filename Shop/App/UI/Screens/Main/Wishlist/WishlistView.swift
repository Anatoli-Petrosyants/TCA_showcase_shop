//
//  WishlistView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.09.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - WishlistView

struct WishlistView {
    let store: StoreOf<WishlistFeature>
}

// MARK: - Views

extension WishlistView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack(alignment: .center) {
                    if viewStore.products.isEmpty {
                        ContentUnavailableView {
                            Label("You don't have any favorites.", systemImage: "heart.fill")
                                .font(.title2)
                                .foregroundColor(Color.black)
                        }                      
                    } else {
                        VStack(spacing: 0) {
                            ZStack {
                                ForEach(viewStore.products.reversed()) { product in
                                    CardView {
                                        VStack {
                                            WebImage(url: product.imageURL)
                                                .resizable()
                                                .indicator(.activity)
                                                .transition(.fade(duration: 0.5))
                                                .scaledToFit()
                                                .padding()
                                            
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(product.title)
                                                    .font(.headlineBold)
                                                
                                                Text(product.description)
                                                    .lineLimit(3)
                                                    .font(.footnote)
                                                    .foregroundColor(.black05)
                                                
                                                Text("\(product.price.currency())")
                                                    .font(.body)
                                            }
                                            .padding()
                                        }
                                    }
                                }
                            }
                            
                            WishlistActionsView(
                                store: self.store.scope(
                                    state: \.actions,
                                    action: WishlistFeature.Action.actions
                                )
                            )
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                .navigationTitle("Wishlist (\(viewStore.products.count))")
            }
            .badge(viewStore.products.count)
        }
    }
}
