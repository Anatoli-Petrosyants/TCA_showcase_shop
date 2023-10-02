//
//  WishlistView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.09.23.
//

import SwiftUI
import ComposableArchitecture
import CardStack

// MARK: - WishlistView

struct WishlistView {
    let store: StoreOf<WishlistReducer>
}

// MARK: - Views

extension WishlistView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                    VStack(spacing: 0) {
                        CardStack(
                            direction: LeftRight.direction,
                            data: viewStore.products,
                            onSwipe: { product, direction in
                                print("Swiped \(product.title) to \(direction)")
                            },
                            content: { product, direction, _ in
                                CardViewWithThumbs(product: product, direction: direction)
                            }
                        )
                        .environment(\.cardStackConfiguration, CardStackConfiguration(
                            maxVisibleCards: 2,
                            swipeThreshold: 0.4,
                            cardOffset: 6,
                            cardScale: 0,
                            animation: .spring()
                        ))

                        WishlistActionsView(
                            store: self.store.scope(
                                state: \.actions,
                                action: WishlistReducer.Action.actions
                            )
                        )
                        .padding(.top, 16)
                    }
                    .padding()
                    .navigationTitle("Wishlist (\(viewStore.products.count))")
            }
            .badge(viewStore.products.count)
        }
    }
}
