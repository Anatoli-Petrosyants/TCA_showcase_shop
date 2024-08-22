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

@Reducer
struct ProductDetailFeature {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: UUID
        let product: Product
        var isFavorite: Bool = false
        var isSharePresented = false
        var isReviewsPresented = false
        
        @Presents var productPhotos: ProductPhotosFeature.State?
        var link = ProductLinkFeature.State(text: "Visit the store", url: URL(string:"https://amazon.com")!)
        var users = ProductUsersFeature.State()
        
        var agreementsAttributedString: AttributedString {
            var result = AttributedString("By tapping you agree our Terms and Conditions and Privacy Policy.")
            
            // We can force unwrap the link range,
            // because we are sure in this case,
            // that `website` string is present.
            let termsRange = result.range(of: "Terms and Conditions")!
            result[termsRange].link = Constant.termsURL
            result[termsRange].underlineStyle = Text.LineStyle(pattern: .solid)
            result[termsRange].foregroundColor = Color.blue
            
            let privacyRange = result.range(of: "Privacy Policy")!
            result[privacyRange].link = Constant.privacyURL
            result[privacyRange].underlineStyle = Text.LineStyle(pattern: .solid)
            result[privacyRange].foregroundColor = Color.blue
            
            return result
        }
        
        let urls = ["https://picsum.photos/id/1/400/600",
                    "https://picsum.photos/id/2/400/600",
                    "https://picsum.photos/id/3/400/600",
                    "https://picsum.photos/id/4/400/600",
                    "https://picsum.photos/id/5/400/600",
                    "https://picsum.photos/id/6/400/600"]
    }
    
    enum Action: BindableAction, Equatable {        
        enum ViewAction: Equatable {
            case onViewAppear
            case onViewPhotosTap
            case onAddProductsTap
            case onFavoriteTap
            case onShareTap
            case onReviewsTap
            case onCloseReviewsTap
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
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.feedbackGenerator) var feedbackGenerator
    @Dependency(\.productsClient) var productsClient
    @Dependency(\.usersClient) var usersClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
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
                    state.productPhotos = ProductPhotosFeature.State(urls: state.urls)
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
                    
                case .onShareTap:
                    state.isSharePresented = true
                    return .none
                    
                case .onReviewsTap:
                    state.isReviewsPresented = true
                    return .none
                    
                case .onCloseReviewsTap:
                    state.isReviewsPresented = false
                    return .none
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
                    Log.info("productResponse: \(data)")
                    return .none

                case let .productResponse(.failure(error)):
                    Log.error("productsResponse: \(error)")
                    return .none
                    
                case let .usersResponse(.success(data)):
                    Log.info("usersResponse: \(data)")
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
                
            case .productPhotos, .link, .users, .delegate, .binding:
                return .none
            }
        }
        .ifLet(\.$productPhotos, action: /Action.productPhotos) {
            ProductPhotosFeature()
        }
    }
}
