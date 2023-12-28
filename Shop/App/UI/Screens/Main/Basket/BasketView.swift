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
    let store: StoreOf<BasketFeature>
    
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

                                VStack(spacing: 8) {
                                    ForEach(viewStore.products) { product in
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
                                                viewStore.send(.onDeleteItemButtonTap(product))
                                            } label: {
                                                Image(systemName: "trash")
                                                    .tint(.red)
                                            }
                                        }
                                        .frame(height: 54)
                                        .confirmationDialog(store: self.store.scope(state: \.$dialog,
                                                                                    action: BasketFeature.Action.dialog))

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
                                    action: BasketFeature.Action.announcement
                                )
                            )

                            Divider()
                                .padding([.leading, .trailing], 24)
                            
                            TopPicksView(
                                store: self.store.scope(
                                    state: \.topPicks,
                                    action: BasketFeature.Action.topPicks
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
                    CaseLet(/BasketFeature.Path.State.checkout,
                        action: BasketFeature.Path.Action.checkout,
                        then: CheckoutView.init(store:)
                    )
                    
                case .details:
                    CaseLet(/BasketFeature.Path.State.details,
                        action: BasketFeature.Path.Action.details,
                        then: ProductDetailView.init(store:)
                    )
                }
            }
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
            .badge(viewStore.products.count)
        }
    }
}

// MARK: BindingViewStore

extension BindingViewStore<BasketFeature.State> {
    var view: BasketView.ViewState {
        BasketView.ViewState(products: self.products,
                             topPicksProducts: self.topPicksProducts,
                             totalPrice: self.totalPrice,
                             toastMessage: self.$toastMessage)
    }
}
