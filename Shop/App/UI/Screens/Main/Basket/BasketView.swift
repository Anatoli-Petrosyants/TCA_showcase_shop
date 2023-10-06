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
    
    struct ViewState: Equatable {
        var products: [Product]
        var topPicksProducts: [Product]
        var totalPrice: String
        @BindingViewState var toastMessage: LocalizedStringKey?
    }
}

// MARK: - Views

extension BasketView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
            NavigationStackStore(
                self.store.scope(state: \.path, action: { .path($0) })
            ) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        if viewStore.products.count > 0 {
                            VStack {
                                HStack(alignment: .firstTextBaseline) {
                                    Text(Localization.Basket.subtotal)
                                        .font(.title1)

                                    Text(viewStore.totalPrice)
                                        .font(.title1Bold)

                                    Spacer()
                                }

                                Button("Proceed to checkout \(viewStore.products.count)") {
                                    viewStore.send(.onProceedToCheckoutButtonTap)
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
                                                viewStore.send(.onDeleteItemButtonTap(product))
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
                            AddProductView(
                                store: self.store.scope(
                                    state: \.addProduct,
                                    action: { .addProduct($0) }
                                )
                            )
                            
                            AnnouncementView(
                                store: self.store.scope(
                                    state: \.announcement,
                                    action: BasketReducer.Action.announcement
                                )
                            )

                            Divider()
                                .padding([.leading, .trailing], 24)
                            
                            TopPicksView(
                                store: self.store.scope(
                                    state: \.topPicks,
                                    action: BasketReducer.Action.topPicks
                                )
                            )
                        }

                        Spacer()
                    }
                }
                .navigationTitle(Localization.Basket.title)
                .modifier(NavigationBarModifier())
            } destination: {
                switch $0 {
                case .checkout:
                    CaseLet(/BasketReducer.Path.State.checkout,
                        action: BasketReducer.Path.Action.checkout,
                        then: CheckoutView.init(store:)
                    )
                    
                case .details:
                    CaseLet(/BasketReducer.Path.State.details,
                        action: BasketReducer.Path.Action.details,
                        then: ProductDetailView.init(store:)
                    )
                }
            }
            .badge(viewStore.products.count)
            .confirmationDialog(store: self.store.scope(state: \.$dialog, action: BasketReducer.Action.dialog))
            .popup(item: viewStore.$toastMessage) { message in
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
        }        
    }
}

// MARK: BindingViewStore

extension BindingViewStore<BasketReducer.State> {
    var view: BasketView.ViewState {
        BasketView.ViewState(products: self.products,
                             topPicksProducts: self.topPicksProducts,
                             totalPrice: self.totalPrice,
                             toastMessage: self.$toastMessage)
    }
}
