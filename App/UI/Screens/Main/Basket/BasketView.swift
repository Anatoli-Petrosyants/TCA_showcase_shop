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
    let store: StoreOf<BasketReducer>
}

// MARK: - Views

extension BasketView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStackStore(
                self.store.scope(state: \.path, action: { .path($0) })
            ) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if viewStore.products.count > 0 {
                            VStack {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("Subtotal")
                                        .font(.title1)

                                    Text(viewStore.totalPrice)
                                        .font(.title1Bold)

                                    Spacer()
                                }

                                Button("Proceed to checkout \(viewStore.products.count)") {
                                    viewStore.send(.view(.onProceedToCheckoutButtonTap))
                                }
                                .buttonStyle(.cta)

                                LazyVStack(spacing: 8) {
                                    ForEach(viewStore.products) { product in
                                        HStack() {
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
                                                viewStore.send(.view(.onDeleteItemButtonTap(product)))
                                            } label: {
                                                Image(systemName: "trash")
                                                    .tint(.red)
                                            }
                                        }
                                        .frame(height: 54)

                                        Divider()
                                    }
                                }
                                .padding(.top, 12)
                            }
                            .padding(24)
                        } else {
                            BasketEmptyView(
                                store: self.store.scope(
                                    state: \.emptyBasket,
                                    action: BasketReducer.Action.emptyBasket
                                )
                            )

                            Divider()
                                .padding([.leading, .trailing], 24)
                        }

                        BasketTopPicksView(
                            store: self.store.scope(
                                state: \.topPicksBasket,
                                action: BasketReducer.Action.topPicksBasket
                            )
                        )

                        Spacer()
                    }
                }
                .navigationTitle("Basket")
                .modifier(NavigationBarModifier())
            } destination: {
                switch $0 {
                case .checkout:
                    CaseLet(/BasketReducer.Path.State.checkout,
                        action: BasketReducer.Path.Action.checkout,
                        then: BasketCheckoutView.init(store:)
                    )
                }
            }
            .badge(viewStore.products.count)
        }
        .confirmationDialog(store: self.store.scope(state: \.$dialog, action: BasketReducer.Action.dialog))
    }
}
