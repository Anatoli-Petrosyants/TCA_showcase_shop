//
//  BasketView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.06.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - BasketView

struct BasketView {
    @Bindable var store: StoreOf<BasketFeature>
}

// MARK: - Views

extension BasketView: View {
    
    var body: some View {
        content
            .onAppear { store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    if store.products.count > 0 {
                        VStack {
                            HStack(alignment: .firstTextBaseline) {
                                Text(Localization.Basket.subtotal)
                                    .font(.title1)

                                Text(store.totalPrice)
                                    .font(.title1Bold)

                                Spacer()
                            }

                            Button("Proceed to checkout \(store.products.count)") {
                                store.send(.view(.onProceedToCheckoutButtonTap))
                            }
                            .buttonStyle(.cta)

                            VStack(spacing: 8) {
                                ForEach(store.products) { product in
                                    HStack {
                                        WebImage(url: product.imageURL)
                                            .resizable()
                                            .indicator(.activity)
                                            .transition(.fade(duration: 0.5))
                                            .scaledToFit()
                                            .frame(width: 32, height: 32)

                                        Text(product.title)
                                            .font(.footnoteBold)

                                        Spacer()

                                        Button {
                                            store.send(.view(.onDeleteItemButtonTap(product)))
                                        } label: {
                                            Image(systemName: "trash")
                                                .tint(.red)
                                        }
                                    }
                                    .frame(height: 54)
                                    .confirmationDialog($store.scope(state: \.dialog, action: \.dialog))

                                    Divider()
                                }
                            }
                            .padding(.top, 12)
                        }
                        .padding(24)
                    } else {
                        AddProductView(
                            store: self.store.scope(
                                state: \.addProduct,
                                action: \.addProduct
                            )
                        )
                        
                        AnnouncementView(
                            store: self.store.scope(
                                state: \.announcement,
                                action: \.announcement
                            )
                        )
                        .padding(.horizontal, 8)
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        VStack(alignment: .leading) {
                            Text(Localization.Basket.categories)
                                .font(.title3Bold)
                                .padding(.horizontal, 8)
                            
                            SearchChipsView(
                                store: self.store.scope(
                                    state: \.chips,
                                    action: \.chips
                                )
                            )
                        }
                        .padding(.horizontal, 8)

                        Divider()
                            .padding(.horizontal, 16)

                        TopPicksView(
                            store: self.store.scope(
                                state: \.topPicks,
                                action: \.topPicks
                            )
                        )
                    }

                    Spacer()
                }
            }
            .navigationTitle(Localization.Basket.title)
            .modifier(NavigationBarModifier())
        } destination: { store in
            switch store.case {
            case let .checkout(store):
                CheckoutView(store: store)
            case let .details(store):
                ProductDetailView(store: store)
            }
        }
        .popup(
            item: $store.toastMessage
        ) { message in
            Text(message)
                .frame(width: 340, height: 60)
                .font(.body)
                .foregroundColor(Color.white)
                .background(Color.black)
                .cornerRadius(30.0)
        } customize: {
            $0
             .type(.floater())
             .position(.top)
             .animation(.spring())
             .closeOnTapOutside(true)
             .closeOnTap(true)
             .autohideIn(3)
        }
        .badge(store.products.count)
    }
}
