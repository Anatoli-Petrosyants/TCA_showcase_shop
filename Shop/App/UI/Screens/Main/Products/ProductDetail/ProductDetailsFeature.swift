//
//  ProductDetail.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies

struct ProductDetailFeature: Reducer {
    
    struct State: Equatable, Identifiable {
        let id: UUID
        let product: Product
        var isFavorite: Bool = false
        
        @PresentationState var productPhotos: ProductPhotosFeature.State?
        var link = ProductLinkFeature.State(text: "view website", url: URL(string:"https://google.com")!)
        var users = ProductUsersFeature.State()
    }
    
    enum Action: Equatable {        
        enum ViewAction: Equatable {
            case onViewAppear
            case onViewPhotosTap
            case onAddProductsTap
            case onFavoriteTap
        }
        
        enum InternalAction: Equatable {
            case loadProducts
            case loadUsers
            case productResponse(TaskResult<Product>)
            case usersResponse(TaskResult<[User]>)
        }
        
        enum Delegate: Equatable {
            case didProductAddedToBasket(Product)
            case didFavoriteChanged(Bool, Product)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case productPhotos(PresentationAction<ProductPhotosFeature.Action>)
        case link(ProductLinkFeature.Action)
        case users(ProductUsersFeature.Action)
    }
    
    @Dependency(\.feedbackGenerator) var feedbackGenerator
    @Dependency(\.productsClient) var productsClient
    @Dependency(\.usersClient) var usersClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Scope(state: \.users, action: /Action.users) {
            ProductUsersFeature()
        }
        
        Scope(state: \.link, action: /Action.link) {
            ProductLinkFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onViewAppear:
                    return .concatenate(
                        .send(.internal(.loadProducts)),
                        .send(.internal(.loadUsers))
                    )
                    
                case .onViewPhotosTap:
                    let urls = ["https://picsum.photos/id/1/400/600",
                                "https://picsum.photos/id/2/400/600",
                                "https://picsum.photos/id/3/400/600",
                                "https://picsum.photos/id/4/400/600",
                                "https://picsum.photos/id/5/400/600",
                                "https://picsum.photos/id/6/400/600"]
                    state.productPhotos = ProductPhotosFeature.State(urls: urls)
                    return .none
                    
                case .onAddProductsTap:
                    return .run { [product = state.product] send in
                        await send(.delegate(.didProductAddedToBasket(product)))
                        await self.feedbackGenerator.selectionChanged()                        
                        await self.dismiss()
                    }
                    
                case .onFavoriteTap:
                    state.isFavorite.toggle()                    
                    return .send(
                        .delegate(
                            .didFavoriteChanged(state.isFavorite, state.product)
                        )
                    )
                }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case .loadUsers:
                    return .run { [product = state.product] send in
                        await send(
                            .internal(
                                .productResponse(
                                    await TaskResult {
                                        try await self.productsClient.product(product.productId)
                                    }
                                )
                            ),
                            animation: .default
                        )
                    }
                    
                case .loadProducts:
                    return .run { send in
                        await send(
                            .internal(
                                .usersResponse(
                                    await TaskResult {
                                        try await self.usersClient.users()
                                    }
                                )
                            ),
                            animation: .default
                        )
                    }
                                        
                case let .productResponse(.success(data)):
                    Log.debug("productResponse: \(data)")
                    return .none

                case let .productResponse(.failure(error)):
                    Log.error("productsResponse: \(error)")
                    return .none
                    
                case let .usersResponse(.success(data)):
                    Log.debug("usersResponse: \(data)")
                    state.users.items.append(contentsOf: data)
                    return .none

                case let .usersResponse(.failure(error)):
                    Log.error("usersResponse: \(error)")
                    return .none
                }
                
            case .productPhotos(.presented):
                return .none
                
            case .productPhotos(.dismiss):
                state.productPhotos = nil
                return .none
                
            case .productPhotos, .link, .users, .delegate:
                return .none
            }
        }
        .ifLet(\.$productPhotos, action: /Action.productPhotos) { ProductPhotosFeature() }
    }
}
