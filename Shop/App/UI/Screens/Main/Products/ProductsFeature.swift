//
//  ProductsFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ProductsFeature {

    @ObservableState
    struct State {
        var isLoading = false
        var productsError: AppError? = nil
        var initalItems: IdentifiedArrayOf<ProductItemFeature.State> = []
        var items: IdentifiedArrayOf<ProductItemFeature.State> = []
        var account = ProductsAccountFeature.State()
        var input = SearchInputFeature.State(placeholder: Localization.Search.inputPlaceholder)
        var segment = SearchSegmentFeature.State()        
        var path = StackState<Path.State>()
    }

    enum Action: BindableAction {
        enum ViewAction {
            case onViewLoad
            case onMenuTap
            case onPulledToRefresh
        }

        enum InternalAction {
            case loadProducts
            case productsResponse(TaskResult<[Product]>)
            case processItems([Product])
        }

        enum Delegate {
            case didProductAddedToBasket(Product)
            case didTopPicksLoaded([Product])
            case didFavoriteChanged(Bool, Product)
            case didSidebarTapped
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case binding(BindingAction<State>)
        case account(ProductsAccountFeature.Action)
        case input(SearchInputFeature.Action)
        case segment(SearchSegmentFeature.Action)        
        case product(id: ProductItemFeature.State.ID, action: ProductItemFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
    }

    struct Path: Reducer {
        enum State: Equatable {
            case details(ProductDetailFeature.State)
            case inAppMessages(InAppMessagesFeature.State)
            case map(MapFeature.State)
            case camera(CameraFeature.State)
            case countries(CountriesFeature.State)
            case healthKit(HealthKitFeature.State)
        }

        enum Action: Equatable {
            case details(ProductDetailFeature.Action)
            case inAppMessages(InAppMessagesFeature.Action)
            case map(MapFeature.Action)
            case camera(CameraFeature.Action)
            case countries(CountriesFeature.Action)
            case healthKit(HealthKitFeature.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: /State.details, action: /Action.details) {
                ProductDetailFeature()
            }

            Scope(state: /State.inAppMessages, action: /Action.inAppMessages) {
                InAppMessagesFeature()
            }

            Scope(state: /State.map, action: /Action.map) {
                MapFeature()
            }

            Scope(state: /State.camera, action: /Action.camera) {
                CameraFeature()
            }

            Scope(state: /State.countries, action: /Action.countries) {
                CountriesFeature()
            }

            Scope(state: /State.healthKit, action: /Action.healthKit) {
                HealthKitFeature()
            }
        }
    }

    private enum CancelID { case products }

    @Dependency(\.productsClient) var productsClient
    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        Scope(state: \.account, action: /Action.account) {
            ProductsAccountFeature()
        }
        
        Scope(state: \.input, action: /Action.input) {
            SearchInputFeature()
        }
        
        Scope(state: \.segment, action: /Action.segment) {
            SearchSegmentFeature()
        }

        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onViewLoad:
                    state.isLoading = true
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
                    state.isLoading = false
                    state.input.isLoading = false

                    return .concatenate(
                        .send(.internal(.processItems(data)), animation: .default),
                        .send(.delegate(.didTopPicksLoaded(Array(data.prefix(6)))))
                    )

                case let .productsResponse(.failure(error)):
                    state.isLoading = false
                    state.input.isLoading = false
                    state.productsError = .underlying(error)
                    return .none

                case let .processItems(data):
                    state.initalItems.removeAll()
                    state.items.removeAll()

                    let items = data.map { ProductItemFeature.State(id: UUID(), product: $0) }
                    state.initalItems.append(contentsOf: items)
                    state.items.append(contentsOf: items)
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
                    state.input = SearchInputFeature.State(placeholder: Localization.Search.inputPlaceholder)
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

            case .binding, .delegate:
                return .none
            }
        }
        .forEach(\.items, action: /Action.product(id:action:)) {
            ProductItemFeature()
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
