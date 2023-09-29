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
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack {
                    CardStack(
                        direction: LeftRight.direction,
                        data: Person.mock,
                        onSwipe: { product, direction in
                            print("Swiped \(product.title) to \(direction)")
                        },
                        content: { product, direction, _ in
                            CardViewWithThumbs(product: product, direction: direction)
                        }
                    )
                    .padding()
                    .scaledToFit()
                    .frame(alignment: .center)
                }
                .navigationTitle("Wishlist \(viewStore.products.count)")
            }
            .badge(viewStore.products.count)
        }
    }
}
