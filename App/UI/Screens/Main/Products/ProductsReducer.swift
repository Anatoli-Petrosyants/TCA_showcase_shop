//
//  ProductsReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import SwiftUI
import ComposableArchitecture

struct ProductsReducer: Reducer {

    struct State: Equatable {
        var isLoading = false
        var isActivityIndicatorVisible = false
        var productsError: AppError? = nil
        var initalItems: IdentifiedArrayOf<ProductItemReducer.State> = []
        var items: IdentifiedArrayOf<ProductItemReducer.State> = []
        var account = ProductAccountReducer.State()
        var input = SearchInputReducer.State(placeholder: Localization.Search.inputPlacholder)
        var segment = SearchSegmentReducer.State()
        var announcement = ProductAnnouncementReducer.State()
        var path = StackState<Path.State>()
    }

    enum Action: BindableAction, Equatable {
        enum ViewAction: Equatable {
            case onViewLoad
            case onMenuTap
            case onPulledToRefresh
        }

        enum InternalAction: Equatable {
            case loadProducts
            case productsResponse(TaskResult<[Product]>)
        }

        enum Delegate: Equatable {
            case didProductAddedToBasket(Product)
            case didTopPicksLoaded([Product])
            case didFavoriteChanged(Bool, Product)
            case didSidebarTapped
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case binding(BindingAction<State>)
        case account(ProductAccountReducer.Action)
        case input(SearchInputReducer.Action)
        case segment(SearchSegmentReducer.Action)
        case announcement(ProductAnnouncementReducer.Action)
        case product(id: ProductItemReducer.State.ID, action: ProductItemReducer.Action)
        case path(StackAction<Path.State, Path.Action>)
    }

    struct Path: Reducer {
        enum State: Equatable {
            case details(ProductDetails.State)
            case inAppMessages(InAppMessagesReducer.State)
            case map(MapReducer.State)
            case camera(CameraReducer.State)
            case countries(CountriesReducer.State)
            case healthKit(HealthKitReducer.State)
        }

        enum Action: Equatable {
            case details(ProductDetails.Action)
            case inAppMessages(InAppMessagesReducer.Action)
            case map(MapReducer.Action)
            case camera(CameraReducer.Action)
            case countries(CountriesReducer.Action)
            case healthKit(HealthKitReducer.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: /State.details, action: /Action.details) {
                ProductDetails()
            }

            Scope(state: /State.inAppMessages, action: /Action.inAppMessages) {
                InAppMessagesReducer()
            }

            Scope(state: /State.map, action: /Action.map) {
                MapReducer()
            }

            Scope(state: /State.camera, action: /Action.camera) {
                CameraReducer()
            }

            Scope(state: /State.countries, action: /Action.countries) {
                CountriesReducer()
            }

            Scope(state: /State.healthKit, action: /Action.healthKit) {
                HealthKitReducer()
            }
        }
    }

    private enum CancelID { case products }

    @Dependency(\.productsClient) var productsClient
    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        Scope(state: \.account, action: /Action.account) {
            ProductAccountReducer()
        }
        
        Scope(state: \.input, action: /Action.input) {
            SearchInputReducer()
        }
        
        Scope(state: \.segment, action: /Action.segment) {
            SearchSegmentReducer()
        }

        Scope(state: \.announcement, action: /Action.announcement) {
            ProductAnnouncementReducer()
        }

        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onViewLoad:
                    state.isActivityIndicatorVisible = true                    
                    return .send(.internal(.loadProducts))

                case .onMenuTap:
                    return .send(.delegate(.didSidebarTapped))

                case .onPulledToRefresh:
                    state.isLoading = true
                    return .send(.internal(.loadProducts))
                }

            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case .loadProducts:                    
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

                case let .productsResponse(.success(data)):
                    state.isActivityIndicatorVisible = false
                    state.isLoading = false
                    state.input.isLoading = false
                    
                    state.initalItems.removeAll()
                    state.items.removeAll()

                    let items = data.map { ProductItemReducer.State(id: UUID(), product: $0) }
                    state.initalItems.append(contentsOf: items)
                    state.items.append(contentsOf: items)
                    
                    let topPicks = Array(data.prefix(6))
                    return .send(.delegate(.didTopPicksLoaded(topPicks)))

                case let .productsResponse(.failure(error)):                    
                    state.productsError = .underlying(error)
                    state.isActivityIndicatorVisible = false
                    state.input.isLoading = false
                    state.isLoading = false
                    return .none
                }

            case let .product(id, productAction):
                switch productAction {
                case let .delegate(.didItemTapped(product)):
                    let productItem = state.items.first(where: { $0.id == id })
                    let isFavorite = productItem?.favorite.isFavorite
                    
                    state.path.append(
                        .details(
                            .init(id: self.uuid(),
                                  product: product,
                                  isFavorite: isFavorite.valueOr(false)
                            )
                        )
                    )
                    return .none
                    
                case let .delegate(.didFavoriteChanged(isFavorite, product)):
                    return .send(.delegate(.didFavoriteChanged(isFavorite, product)))

                default:
                    return .none
                }

            case let .account(accountAction):
                switch accountAction {
                case .delegate(.didTap):
                    return .send(.delegate(.didSidebarTapped))

                default:
                    return .none
                }
                
            case let .segment(segmentAction):
                switch segmentAction {
                case let .delegate(.didSegmentedChanged(segment)):
                    state.input = SearchInputReducer.State(placeholder: Localization.Search.inputPlacholder)
                    state.input.isLoading = true
                    return .run { send in
                        if segment.isEmpty {
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
                        } else {
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

            // path actions
            case let .path(pathAction):
                switch pathAction {
                case let .element(id: _, action: .details(.delegate(.didProductAddedToBasket(product)))):
                    return .send(.delegate(.didProductAddedToBasket(product)))
                    
                case let .element(id: _, action: .details(.delegate(.didFavoriteChanged(isFavorite, product)))):
                    if let index = state.items.firstIndex(where: { $0.product.id == product.id }) {
                        state.items[index].favorite.isFavorite = isFavorite
                    }
                    return .send(.delegate(.didFavoriteChanged(isFavorite, product)))

                case let .element(id: _, action: .countries(.delegate(.didCountryCodeSelected(code)))):     
                    state.account.countryCode = code
                    return .none

                default:
                    return .none
                }

            case .binding, .delegate, .announcement:
                return .none
            }
        }
        .forEach(\.items, action: /Action.product(id:action:)) {
            ProductItemReducer()
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
