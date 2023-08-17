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
                self.store.scope(state: \.path, action: ProductsReducer.Action.path)
            ) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ProductAnnouncementView(
                            store: self.store.scope(
                                state: \.announcement,
                                action: ProductsReducer.Action.announcement
                            )
                        )

                        ForEachStore(
                            self.store.scope(state: \.items,
                                             action: ProductsReducer.Action.product(id: action:))
                        ) { itemStore in
                            ProductItemView(store: itemStore)
                        }
                    }
                }
                .modifier(NavigationBarModifier())
                .loader(isLoading: viewStore.isActivityIndicatorVisible)
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
                                Label("Menu", systemImage: "line.3.horizontal.circle")
                            }

                            Button {
                                viewStore.send(.view(.onViewLoad))
                            } label: {
                                Label("Refresh products", systemImage: "arrow.clockwise.circle")
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


//VStack {
//    Group {
//        (/Loadable<IdentifiedArrayOf<ProductItemReducer.State>>.loading).extract(from: viewStore.data).map {
//            ProgressView()
//                .progressViewStyle(.main)
//        }
//
//        (/Loadable<IdentifiedArrayOf<ProductItemReducer.State>>.loaded).extract(from: viewStore.data).map { reducers in
//            ScrollView {
//                LazyVStack(spacing: 0) {
//                    ProductAnnouncementView(
//                        store: self.store.scope(
//                            state: \.announcement,
//                            action: ProductsReducer.Action.announcement
//                        )
//                    )
//
//                    ForEach(reducers) { reducer in
//                        let store = Store(initialState: reducer, reducer: ProductItemReducer())
//                        ProductItemView(store: store)
//                    }
//                }
//            }
//        }
//    }
//}
