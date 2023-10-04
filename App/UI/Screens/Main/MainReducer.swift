//
//  MainReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.04.23.
//

import SwiftUI
import ComposableArchitecture

enum Tab: Int, CaseIterable {
    case products = 0
    case search
    case wishlist
    case basket
    case account
    
    var icon: String {
        switch self {
            case .products: return "rectangle.stack.fill"
            case .search: return "magnifyingglass"
            case .wishlist: return "heart"
            case .basket: return "basket.fill"
            case .account: return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .products: return "Home"
        case .search: return "Search"
        case .wishlist: return "Wishlist"
        case .basket: return "Basket"
        case .account: return "Account"
        }
    }
}

struct MainReducer: Reducer {
    
    struct State: Equatable {
        var currentTab = Tab.products
        
        var products = ProductsReducer.State()
        var search = SearchReducer.State()
        var wishlist = WishlistReducer.State()
        var basket = BasketReducer.State()
        var account = AccountReducer.State()
        var sidebar = SidebarReducer.State()
    }
    
    enum Action: Equatable {        
        case onTabChanged(Tab)
        case products(ProductsReducer.Action)
        case search(SearchReducer.Action)
        case wishlist(WishlistReducer.Action)
        case basket(BasketReducer.Action)
        case account(AccountReducer.Action)
        case sidebar(SidebarReducer.Action)
        
        enum Delegate: Equatable {
            case didLogout
        }
        
        case delegate(Delegate)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.products, action: /Action.products) {
            ProductsReducer()
        }
        
        Scope(state: \.search, action: /Action.search) {
            SearchReducer()
        }
        
        Scope(state: \.wishlist, action: /Action.wishlist) {
            WishlistReducer()
        }
        
        Scope(state: \.basket, action: /Action.basket) {
            BasketReducer()
        }

        Scope(state: \.account, action: /Action.account) {
            AccountReducer()
        }
        
        Scope(state: \.sidebar, action: /Action.sidebar) {
            SidebarReducer()
        }
        
        Reduce { state, action in
            switch action {
            case let .onTabChanged(tab):
                state.currentTab = tab
                return .none
            
            case let .products(.delegate(.didProductAddedToBasket(product))):
                state.basket.products.append(product)
                return .none
                
            case let .products(.delegate(.didTopPicksLoaded(products))):
                state.basket.topPicksProducts.removeAll()
                state.basket.topPicksProducts.append(contentsOf: products)
                return .none
                
            case let .products(.delegate(.didFavoriteChanged(isFavorite, product))):
                if isFavorite {
                    state.wishlist.products.append(product)
                } else {
                    if let index = state.wishlist.products.firstIndex(of: product) {
                        state.wishlist.products.remove(at: index)
                    }
                }
                return .none
                
            case .products(.delegate(.didSidebarTapped)):
                state.sidebar.isVisible.toggle()
                return .none
                
            case let .search(.delegate(.didItemAddedToBasket(product))):
                state.basket.products.append(product)
                return .none
                
            case let .search(.delegate(.didFavoriteChanged(isFavorite, product))):
                if isFavorite {
                    state.wishlist.products.append(product)
                } else {
                    if let index = state.wishlist.products.firstIndex(of: product) {
                        state.wishlist.products.remove(at: index)
                    }
                }
                return .none
                
            case let .wishlist(.delegate(.didProductAddedToBasket(product))):
                state.basket.products.append(product)
                return .none
                
            case let .wishlist(.delegate(.didProductRemovedFromFavorites(product))):
                if let index = state.products.items.firstIndex(where: { $0.product.id == product.id }) {
                    state.products.items[index].favorite.isFavorite = false
                }
                
                if let index = state.search.items.firstIndex(where: { $0.product.id == product.id }) {
                    state.search.items[index].favorite.isFavorite = false
                }
                return .none
                
            case .basket(.delegate(.didAddProductsTapped)):
                state.currentTab = .products
                return .none

            case let .basket(.delegate(.didTopPickAddedToBasket(product))):
                state.basket.products.append(product)
                return .none
                
            case .account(.delegate(.didLogout)):                
                return .send(.delegate(.didLogout))
                
            case let .sidebar(.delegate(.didSidebarTapped(type))):
                switch type {
                case .logout:
                    return .send(.delegate(.didLogout))
                    
                case .messages:
                    state.products.path.append(.inAppMessages(.init()))
                    return .none
                    
                case .map:
                    state.products.path.append(.map(.init()))
                    return .none
                    
                case .camera:
                    state.products.path.append(.camera(.init()))
                    return .none
                    
                case .countries:
                    state.products.path.append(.countries(.init()))
                    return .none
                    
                case .healthKit:
                    state.products.path.append(.healthKit(.init()))
                    return .none
                    
                default:
                    return .none
                }
                
            case .products, .search, .wishlist, .basket, .account, .sidebar, .delegate:
                return .none
            }
            
//            func updateFavorites(isFavorite: Bool, product: Product) {
//
//            }
        }
    }
}
