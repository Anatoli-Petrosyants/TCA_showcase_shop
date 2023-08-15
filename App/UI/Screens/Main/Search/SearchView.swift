//
//  SearchView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 10.07.23.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation

// MARK: - SearchView

struct SearchView {
    let store: StoreOf<SearchReducer>
    
    var gridItems: [GridItem] = [
        .init(.flexible(), spacing: 8, alignment: .top),
        .init(.flexible(), spacing: 8, alignment: .top)
    ]
}

// MARK: - Views

extension SearchView: View {
    
    var body: some View {
        content
            .onLoad { ViewStore(self.store).send(.view(.onViewLoad)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStackStore(
                self.store.scope(state: \.path, action: SearchReducer.Action.path)
            ) {
                ScrollView {
                    LazyVGrid(columns: gridItems,
                              pinnedViews: [.sectionHeaders])
                    {
                        Section {
                            ForEachStore(
                                self.store.scope(state: \.items,
                                                 action: SearchReducer.Action.product(id: action:))
                            ) { itemStore in
                                SearchProductItemView(store: itemStore)
                            }
                        } header: {
                            VStack {
                                SearchInputView(
                                    store: self.store.scope(
                                        state: \.input,
                                        action: SearchReducer.Action.input
                                    )
                                )
                                .padding([.leading, .trailing], 8)
                                .padding(.top, 1)

                                SearchSegmentView(
                                    store: self.store.scope(
                                        state: \.segment,
                                        action: SearchReducer.Action.segment
                                    )
                                )
                                .padding([.leading, .trailing], 8)
                                .padding(.bottom, 16)
                            }
                            .background(Color(uiColor: UIColor(named: "white")!))
                        }
                    }
                    .padding([.leading, .trailing], 8)
                    .aspectRatio(1.0, contentMode: .fit)
                }
                .dismissKeyboardOnTap()
                .navigationTitle("Search")
                .modifier(NavigationBarModifier())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SearchWishlistView(
                            store: self.store.scope(
                                state: \.wishlist,
                                action: SearchReducer.Action.wishlist
                            )
                        )
                    }
                }
            }
            destination: {
                switch $0 {
                case .details:
                    CaseLet(
                        state: /SearchReducer.Path.State.details,
                        action: SearchReducer.Path.Action.details,
                        then: ProductDetailsView.init(store:)
                    )
                }
            }
        }
    }
}
