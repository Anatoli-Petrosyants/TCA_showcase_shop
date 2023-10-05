//
//  ProductsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ProductsView

struct ProductsView {
    let store: StoreOf<ProductsReducer>
    
    var gridItems: [GridItem] = [
        .init(.flexible(), spacing: 8, alignment: .top),
        .init(.flexible(), spacing: 8, alignment: .top)
    ]
}

// MARK: - Views

extension ProductsView: View {

    var body: some View {
        content
            .onLoad { self.store.send(.view(.onViewLoad)) }
    }

    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStackStore(
                self.store.scope(state: \.path, action: { .path($0) })
            ) {
//                ScrollView {
//                    LazyVStack(spacing: 0) {
//                        ProductAnnouncementView(
//                            store: self.store.scope(
//                                state: \.announcement,
//                                action: ProductsReducer.Action.announcement
//                            )
//                        )
//
//                        ForEachStore(
//                            self.store.scope(state: \.items,
//                                             action: ProductsReducer.Action.product(id: action:))
//                        ) { itemStore in
//                            ProductItemView(store: itemStore)
//                        }
//                    }
//                }
                ScrollView {
                    LazyVGrid(columns: gridItems,
                              pinnedViews: [.sectionHeaders])
                    {
                        Section {
                            ForEachStore(
                                self.store.scope(state: \.items,
                                                 action: ProductsReducer.Action.product(id: action:))
                            ) { itemStore in                                
                                ProductItemView(store: itemStore)
                            }
                        } header: {
//                            VStack {
//                                SearchInputView(
//                                    store: self.store.scope(
//                                        state: \.input,
//                                        action: SearchReducer.Action.input
//                                    )
//                                )
//                                .padding([.leading, .trailing], 8)
//                                .padding(.top, 1)
//
//                                SearchSegmentView(
//                                    store: self.store.scope(
//                                        state: \.segment,
//                                        action: SearchReducer.Action.segment
//                                    )
//                                )
//                                .padding([.leading, .trailing], 8)
//                                .padding(.bottom, 16)
//                            }
//                            .background(Color.white)
                        }
                    }
                    .padding([.leading, .trailing], 8)
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .modifier(NavigationBarModifier())
                .loader(isLoading: viewStore.isActivityIndicatorVisible)
                // .redacted(reason: viewStore.isActivityIndicatorVisible ? .placeholder : [])
                .onError(error: viewStore.productsError, action: {
                    viewStore.send(.view(.onViewLoad))
                })
                .refreshable {
                    await viewStore.send(.view(.onPulledToRefresh), while: \.isLoading)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        ProductAccountView(
                            store: self.store.scope(
                                state: \.account,
                                action: ProductsReducer.Action.account
                            )
                        )
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                viewStore.send(.view(.onMenuTap))
                            } label: {
                                Label(Localization.Product.toolbarItemMenu,
                                      systemImage: "line.3.horizontal.circle")
                            }

                            Button {
                                viewStore.send(.view(.onViewLoad))
                            } label: {
                                Label(Localization.Product.toolbarItemRefresh,
                                      systemImage: "arrow.clockwise.circle")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            } destination: {
                switch $0 {
                case .details:
                    CaseLet(/ProductsReducer.Path.State.details,
                        action: ProductsReducer.Path.Action.details,
                        then: ProductDetailsView.init(store:)
                    )

                case .inAppMessages:
                    CaseLet(/ProductsReducer.Path.State.inAppMessages,
                        action: ProductsReducer.Path.Action.inAppMessages,
                        then: InAppMessagesView.init(store:)
                    )

                case .map:
                    CaseLet(/ProductsReducer.Path.State.map,
                        action: ProductsReducer.Path.Action.map,
                        then: MapView.init(store:)
                    )

                case .camera:
                    CaseLet(/ProductsReducer.Path.State.camera,
                        action: ProductsReducer.Path.Action.camera,
                        then: CameraView.init(store:)
                    )

                case .countries:
                    CaseLet(/ProductsReducer.Path.State.countries,
                        action: ProductsReducer.Path.Action.countries,
                        then: CountriesView.init(store:)
                    )

                case .healthKit:
                    CaseLet(/ProductsReducer.Path.State.healthKit,
                        action: ProductsReducer.Path.Action.healthKit,
                        then: HealthKitView.init(store:)
                    )
                }
            }
        }
    }
}
