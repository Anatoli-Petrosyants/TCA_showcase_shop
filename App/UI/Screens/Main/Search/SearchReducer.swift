//
//  SearchReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 10.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct SearchReducer: ReducerProtocol {
    
    struct State: Equatable {
        var items: IdentifiedArrayOf<SearchProductItemReducer.State> = []
        var initalItems: IdentifiedArrayOf<SearchProductItemReducer.State> = []
        var wishlist = SearchWishlistReducer.State()
        var input = SearchInputReducer.State()
        var segment = SearchSegmentReducer.State()
        var path = StackState<Path.State>()
    }
    
    enum Action: BindableAction, Equatable {
        enum ViewAction: Equatable {
            case onViewLoad
            case onRefresh
        }
        
        enum InternalAction: Equatable {
            case productsResponse(TaskResult<[Product]>)
            case processItems([Product])
        }
        
        enum Delegate: Equatable {
            case didItemAddedToBasket(Product)
        }
        
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case wishlist(SearchWishlistReducer.Action)
        case input(SearchInputReducer.Action)
        case segment(SearchSegmentReducer.Action)
        case product(id: SearchProductItemReducer.State.ID, action: SearchProductItemReducer.Action)
        case binding(BindingAction<State>)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    struct Path: ReducerProtocol {
        enum State: Equatable {
            case details(ProductDetails.State)
        }

        enum Action: Equatable {
            case details(ProductDetails.Action)
        }

        var body: some ReducerProtocol<State, Action> {
            Scope(state: /State.details, action: /Action.details) {
                ProductDetails()
            }
        }
    }
    
    private enum CancelID { case products }
    
    @Dependency(\.productsClient) var productsClient
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.wishlist, action: /Action.wishlist) {
            SearchWishlistReducer()
        }
        
        Scope(state: \.input, action: /Action.input) {
            SearchInputReducer()
        }
        
        Scope(state: \.segment, action: /Action.segment) {
            SearchSegmentReducer()
        }
        
        Reduce { state, action in
            switch action {
            /// view actions
            case let .view(viewAction):
                switch viewAction {
                case .onViewLoad:
                    state.input.isLoading = true
                    return .run { send in
                        await send(
                            .internal(
                                .productsResponse(
                                    await TaskResult {
                                        try await self.productsClient.products()
                                    }
                                )
                            ),
                            animation: .default
                        )
                    }
                    .cancellable(id: CancelID.products)
                    
                case .onRefresh:
                    return .run { send in
                        await send(
                            .internal(
                                .productsResponse(
                                    await TaskResult {
                                        try await self.productsClient.products()
                                    }
                                )
                            ),
                            animation: .default
                        )
                    }
                    .cancellable(id: CancelID.products)
                }
            
            case let .segment(segmentAction):
                switch segmentAction {
                case let .delegate(.didSegmentedChanged(segment)):
                    state.input = SearchInputReducer.State()
                    state.wishlist.count = 0
                    return .run { send in
                        await send(
                            .internal(
                                .productsResponse(
                                    await TaskResult {
                                        try await self.productsClient.productsWithCategory(
                                            .init(category: segment)
                                        )
                                    }
                                )
                            ),
                            animation: .default
                        )
                    }
                    .cancellable(id: CancelID.products)

                default:
                    return .none
                }
                
            case let .input(inputAction):
                switch inputAction {
                case let .delegate(.didSearchQueryChanged(query)):
                    let searchItems = state.initalItems.filter {
                        $0.product.title.lowercased().contains(query.lowercased())                        
                    }
                    state.items.removeAll()
                    state.items.append(contentsOf: searchItems)
                    return .none

                case .delegate(.didSearchQueryCleared):
                    state.items.removeAll()
                    state.items.append(contentsOf: state.initalItems)
                    return .cancel(id: CancelID.products)
                    
                default:
                    return .none
                }
                
            case let .product(_, productAction):
                switch productAction {
                case let .delegate(.didItemTapped(product)):
                    state.path.append(.details(.init(id: self.uuid(), product: product)))
                    return .none
                    
                case let .delegate(.didFavoriteTapped(isFavorite)):
                    let count = state.wishlist.count
                    state.wishlist.count = isFavorite ? (count + 1) : (count - 1)
                    return .none
                    
                default:                    
                    return .none
                }
                
            /// internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .productsResponse(.success(data)):
                    state.input.isLoading = false
                    return .send(.internal(.processItems(data)), animation: .default)

                case let .productsResponse(.failure(error)):
                    Log.debug("productsResponse: \(error)")
                    state.input.isLoading = false
                    return .none
                    
                case let .processItems(data):
                    state.initalItems.removeAll()
                    state.items.removeAll()
                    
                    let items = data.map { SearchProductItemReducer.State(id: UUID(), product: $0) }
                    state.initalItems.append(contentsOf: items)
                    state.items.append(contentsOf: items)
                    return .none
                }
                
            // path actions
            case let .path(pathAction):
                switch pathAction {
                case let .element(id: _, action: .details(.delegate(.didItemAdded(product)))):
                    state.path.removeAll()
                    return .send(.delegate(.didItemAddedToBasket(product)))

                default:
                    return .none
                }
                
            case .delegate, .binding, .wishlist:
                return .none
            }
        }
        .forEach(\.items, action: /Action.product(id: action:)) {
            SearchProductItemReducer()
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
