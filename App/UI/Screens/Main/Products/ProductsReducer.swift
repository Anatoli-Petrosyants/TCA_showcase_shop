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
        var items: IdentifiedArrayOf<ProductItemReducer.State> = []
        var account = ProductAccountReducer.State()
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
            case didItemAddedToBasket(Product)
            case didTopPicksLoaded([Product])
            case didSidebarTapped
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case binding(BindingAction<State>)
        case account(ProductAccountReducer.Action)
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

                    let items = data.map { ProductItemReducer.State(id: UUID(), product: $0) }
                    state.items.append(contentsOf: items)
                    
                    let topPicks = Array(data.prefix(6))
                    return .send(.delegate(.didTopPicksLoaded(topPicks)))

                case let .productsResponse(.failure(error)):                    
                    state.productsError = .underlying(error)
                    state.isActivityIndicatorVisible = false
                    state.isLoading = false
                    return .none
                }

            case let .product(_, productAction):
                switch productAction {
                case let .delegate(.didItemTapped(product)):
                    state.path.append(.details(.init(id: self.uuid(), product: product)))
                    return .none

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

            // path actions
            case let .path(pathAction):
                switch pathAction {
                case let .element(id: _, action: .details(.delegate(.didItemAdded(product)))):                    
                    return .send(.delegate(.didItemAddedToBasket(product)))

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
