//
//  MainReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.04.23.
//

import SwiftUI
import ComposableArchitecture

enum Tab {
    case products, search, basket, account
}

struct MainReducer: ReducerProtocol {
    
    struct State: Equatable {
        var currentTab = Tab.products
        
        var products = ProductsReducer.State()
        var search = SearchReducer.State()
        var basket = BasketReducer.State()
        var account = AccountReducer.State()
        var sidebar = SidebarReducer.State()
    }
    
    enum Action: Equatable {        
        case onTabChanged(Tab)
        case products(ProductsReducer.Action)
        case search(SearchReducer.Action)
        case basket(BasketReducer.Action)
        case account(AccountReducer.Action)
        case sidebar(SidebarReducer.Action)
        
        enum Delegate: Equatable {
            case didLogout
        }
        
        case delegate(Delegate)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.products, action: /Action.products) {
            ProductsReducer()
        }
        
        Scope(state: \.search, action: /Action.search) {
            SearchReducer()
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
            
            case let .products(.delegate(.didItemAddedToBasket(product))):
                state.basket.products.append(product)
                return .none
                
            case .products(.delegate(.didSidebarTapped)):
                state.sidebar.isVisible.toggle()
                return .none
                
            case let .search(.delegate(.didItemAddedToBasket(product))):
                state.basket.products.append(product)
                return .none
                
            case .basket(.delegate(.didAddProductsTapped)):
                state.currentTab = .products
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
                
            case .products, .search, .basket, .account, .sidebar, .delegate:
                return .none
            }
        }
    }
}
