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
        var products: IdentifiedArrayOf<ProductItemFeature.State> = []
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
        case products(IdentifiedActionOf<ProductItemFeature>)
        case path(StackActionOf<Path>)
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case details(ProductDetailFeature)
//        case inAppMessages(InAppMessagesFeature)
//        case map(MapFeature)
//        case camera(CameraFeature)
//        case countries(CountriesFeature)
//        case healthKit(HealthKitFeature)
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
                    state.products.removeAll()

                    let items = data.map { ProductItemFeature.State(id: UUID(), product: $0) }
                    state.initalItems.append(contentsOf: items)
                    state.products.append(contentsOf: items)
                    return .none
                }

            case let .products(productAction):
                switch productAction {
                case let .element(id: _, action: .delegate(.didItemTapped(product))):
                    let productItem = state.products.first(where: { $0.id == product.id })
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
                    
                case let .element(id: _, action: .delegate(.didFavoriteChanged(isFavorite, product))):
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
                    state.products.removeAll()
                    state.products.append(contentsOf: searchItems)
                    return .none

                case .delegate(.didSearchQueryCleared):
                    state.products.removeAll()
                    state.products.append(contentsOf: state.initalItems)
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
                    if let index = state.products.firstIndex(where: { $0.product.id == product.id }) {
                        state.products[index].favorite.isFavorite = isFavorite
                    }
                    return .send(.delegate(.didFavoriteChanged(isFavorite, product)))

//                case let .element(id: _, action: .countries(.delegate(.didCountryCodeSelected(code)))):     
//                    state.account.countryCode = code
//                    return .none

                default:
                    return .none
                }

            case .binding, .delegate:
                return .none
            }
        }
//        .forEach(\.items, action: /Action.product(id:action:)) {
//            ProductItemFeature()
//        }
        .forEach(\.products, action: \.products) {
            ProductItemFeature()
        }
        .forEach(\.path, action: \.path)
    }
}
