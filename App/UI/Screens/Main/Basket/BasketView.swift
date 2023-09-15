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
            NavigationStack {
                VStack(alignment: .leading, spacing: 24) {
                    if viewStore.products.count > 0 {
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

                        List {
                            ForEach(viewStore.products, id: \.self) { product in
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
                            }
                        }
                        .listStyle(.grouped)
                        .scrollContentBackground(.hidden)
                        .environment(\.defaultMinListRowHeight, 64)
                    } else {
                        BasketEmptyView(
                            store: self.store.scope(
                                state: \.emptyBasket,
                                action: BasketReducer.Action.emptyBasket
                            )
                        )
                        
                        Divider()
                        
                        HStack {
                            Text("Top Picks")
                                .font(.title3Bold)
                            
                            Text("(\(viewStore.topPicks.count) items)")
                                .font(.title3)
                            
                            Spacer()
                        }
                    }

                    Spacer()
                }
                .padding(24)                
                .navigationTitle("Basket")
                .modifier(NavigationBarModifier())
            }
            .badge(viewStore.products.count)
        }
        .confirmationDialog(store: self.store.scope(state: \.$dialog, action: BasketReducer.Action.dialog))
    }
}
