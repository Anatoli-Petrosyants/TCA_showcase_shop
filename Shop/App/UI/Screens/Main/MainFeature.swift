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
    case wishlist
    case basket
    case notifications
    case account
    
    var icon: String {
        switch self {
            case .products: return "magnifyingglass"
            case .wishlist: return "heart"
            case .basket: return "basket.fill"
            case .notifications: return "bell.fill"
            case .account: return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .products: return "Serach"
        case .wishlist: return "Wishlist"
        case .basket: return "Basket"
        case .notifications: return "Notifications"
        case .account: return "Account"
        }
    }
}

@Reducer
struct MainFeature {
    
    @ObservableState
    struct State {
        var currentTab = Tab.products
        
        var sidebar = SidebarFeature.State()
        var products = ProductsFeature.State()
        var wishlist = WishlistFeature.State()
        var basket = BasketFeature.State()
        var notifications = NotificationsFeature.State()
        var account = AccountFeature.State()
    }
    
    enum Action: BindableAction {
        case onTabChanged(Tab)
        case addNotifications(Notification)
        
        case sidebar(SidebarFeature.Action)
        case products(ProductsFeature.Action)
        case wishlist(WishlistFeature.Action)
        case basket(BasketFeature.Action)
        case notifications(NotificationsFeature.Action)
        case account(AccountFeature.Action)
        
        enum Delegate: Equatable {
            case didLogout
        }
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.sidebar, action: /Action.sidebar) {
            SidebarFeature()
        }
        
        Scope(state: \.products, action: /Action.products) {
            ProductsFeature()
        }
        
        Scope(state: \.wishlist, action: /Action.wishlist) {
            WishlistFeature()
        }
        
        Scope(state: \.basket, action: /Action.basket) {
            BasketFeature()
        }

        Scope(state: \.notifications, action: /Action.notifications) {
            NotificationsFeature()
        }
        
        Scope(state: \.account, action: /Action.account) {
            AccountFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .onTabChanged(tab):
                state.currentTab = tab
                return .none
                
            case let .addNotifications(notification):
                state.notifications.items.append(notification)
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
                
            case let .wishlist(.delegate(.didProductAddedToBasket(product))):
                state.basket.products.append(product)
                return .none
                
            case let .wishlist(.delegate(.didProductRemovedFromFavorites(product))):
                if let index = state.products.items.firstIndex(where: { $0.product.id == product.id }) {
                    state.products.items[index].favorite.isFavorite = false
                }
                return .none
                
            case .basket(.delegate(.didAddProductsTapped)):
                state.currentTab = .products
                return .none

            case let .basket(.delegate(.didTopPickAddedToBasket(product))):
                state.basket.products.append(product)
                return .none
                
            case .basket(.delegate(.didSuccessfullyCheckoutProducts)):
                state.notifications.items.append(contentsOf: [.checkout])
                return .none
                
            case .notifications(.delegate(.didAccountNotificationTapped)):
                state.currentTab = .account
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
                
            case .products, .wishlist, .basket, .notifications, .account, .sidebar, .delegate, .binding:
                return .none
            }
        }
    }
}
