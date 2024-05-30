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
    @Bindable var store: StoreOf<ProductsFeature>

    var gridItems: [GridItem] {
        if UIDevice.isIPad {
            [
                .init(.flexible(), spacing: 8, alignment: .top),
                .init(.flexible(), spacing: 8, alignment: .top),
                .init(.flexible(), spacing: 8, alignment: .top)
            ]
        } else {
            [
                .init(.flexible(), spacing: 8, alignment: .top),
                .init(.flexible(), spacing: 8, alignment: .top)
            ]
        }
    }
}

// MARK: - Views

extension ProductsView: View {

    var body: some View {
        content
            .onLoad { self.store.send(.view(.onViewLoad)) }
    }

    @ViewBuilder private var content: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: gridItems, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEachStore(self.store.scope(state: \.products, action: \.products)) { productStore in
                            ProductItemView(store: productStore)
                        }
                        .padding(.top, 8)
                    } header: {
                        VStack {
                            SearchInputView(
                                store: self.store.scope(
                                    state: \.input, 
                                    action: \.input
                                )
                            )

                            SearchSegmentView(
                                store: self.store.scope(
                                    state: \.segment,
                                    action: \.segment
                                )
                            )
                        }
                        .padding([.top, .bottom], 8)
                        .background(Color.white)
                    }
                }
                .padding([.leading, .trailing], 8)
            }
            .modifier(NavigationBarModifier())
            .loader(isLoading: store.isLoading)
            // .redacted(reason: viewStore.isActivityIndicatorVisible ? .placeholder : [])
            .onError(error: store.productsError, action: {
                store.send(.view(.onViewLoad))
            })
//            .refreshable {
//                await store.send(.view(.onPulledToRefresh), while: \.isLoading)
//            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ProductsAccountView(
                        store: self.store.scope(
                            state: \.account,
                            action: \.account
                        )
                    )
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            store.send(.view(.onMenuTap))
                        } label: {
                            Label(Localization.Product.toolbarItemMenu,
                                  systemImage: "line.3.horizontal.circle")
                        }
                        
                        Button {
                            store.send(.view(.onViewLoad))
                        } label: {
                            Label(Localization.Product.toolbarItemRefresh,
                                  systemImage: "arrow.clockwise.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        } destination: { store in
            switch store.case {
            case let .details(store):
                ProductDetailView(store: store)
//            case .inAppMessages(store):
//                InAppMessagesView(store: store)
//            case .map(store):
//                MapView(store: store)
//            case .camera(store):
//                CameraView(store: store)
//            case .countries(store):
//                CountriesView(store: store)
//            case .healthKit(store):
//                HealthKitView(store: store)
            }
        }
    }
}
