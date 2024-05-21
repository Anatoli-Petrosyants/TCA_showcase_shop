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
                        ForEachStore(
                            self.store.scope(state: \.items,
                                             action: ProductsFeature.Action.product(id: action:))
                        ) { itemStore in
                            ProductItemView(store: itemStore)
                        }
                        .padding(.top, 8)
                    } header: {
                        VStack {
                            SearchInputView(
                                store: self.store.scope(
                                    state: \.input,
                                    action: ProductsFeature.Action.input
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
            
//        } destination: {
//            switch $0 {
//            case .details:
//                CaseLet(/ProductsFeature.Path.State.details,
//                    action: ProductsFeature.Path.Action.details,
//                    then: ProductDetailView.init(store:)
//                )
//
//            case .inAppMessages:
//                CaseLet(/ProductsFeature.Path.State.inAppMessages,
//                    action: ProductsFeature.Path.Action.inAppMessages,
//                    then: InAppMessagesView.init(store:)
//                )
//
//            case .map:
//                CaseLet(/ProductsFeature.Path.State.map,
//                    action: ProductsFeature.Path.Action.map,
//                    then: MapView.init(store:)
//                )
//
//            case .camera:
//                CaseLet(/ProductsFeature.Path.State.camera,
//                    action: ProductsFeature.Path.Action.camera,
//                    then: CameraView.init(store:)
//                )
//
//            case .countries:
//                CaseLet(/ProductsFeature.Path.State.countries,
//                    action: ProductsFeature.Path.Action.countries,
//                    then: CountriesView.init(store:)
//                )
//
//            case .healthKit:
//                CaseLet(/ProductsFeature.Path.State.healthKit,
//                    action: ProductsFeature.Path.Action.healthKit,
//                    then: HealthKitView.init(store:)
//                )
//            }
//        }
    }
}
