//
//  BasketReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.06.23.
//

import SwiftUI
import ComposableArchitecture

struct BasketReducer: Reducer {
    
    struct State: Equatable {
        var products: [Product] = []
        var topPicks: [Product] = []
        var totalPrice: String = "$0.00"
        var emptyBasket = BasketEmptyReducer.State()
        var topPicksBasket = BasketTopPicksReducer.State()
        
        @PresentationState var dialog: ConfirmationDialogState<Action.DialogAction>?
        var path = StackState<Path.State>()
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onViewAppear
            case onDeleteItemButtonTap(Product)
            case onProceedToCheckoutButtonTap
            case onAddProductsButtonTap
        }
        
        enum InternalAction: Equatable {
            case deleteProduct(Product)
        }
        
        enum Delegate: Equatable {
            case didAddProductsTapped
        }
        
        enum DialogAction: Equatable {
            case confirmProductDeletion(Product)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case emptyBasket(BasketEmptyReducer.Action)
        case topPicksBasket(BasketTopPicksReducer.Action)
        case dialog(PresentationAction<DialogAction>)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case checkout(BasketCheckoutReducer.State)
        }

        enum Action: Equatable {
            case checkout(BasketCheckoutReducer.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: /State.checkout, action: /Action.checkout) {
                BasketCheckoutReducer()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.emptyBasket, action: /Action.emptyBasket) {
            BasketEmptyReducer()
        }
        
        Scope(state: \.topPicksBasket, action: /Action.topPicksBasket) {
            BasketTopPicksReducer()
        }
        
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onViewAppear:
                    state.totalPrice = totalPrice(state.products)                    
                    state.topPicksBasket.topPicks = state.topPicks
                    return .none
                    
                case .onProceedToCheckoutButtonTap:
                    state.path.append(.checkout(.init()))
                    return .none
                    
                case let .onDeleteItemButtonTap(product):
                    state.dialog = ConfirmationDialogState {
                        TextState("Confirmation dialog")
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState("Cancel")
                        }
                        ButtonState(role: .destructive, action: .confirmProductDeletion(product)) {
                            TextState("Remove")
                        }
                    } message: {
                        TextState("Are you sure you want to remove '\(product.title)' from list.")
                    }
                    return .none
                    
                case .onAddProductsButtonTap:                    
                    return .send(.delegate(.didAddProductsTapped))
                }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .deleteProduct(product):
                    if let index = state.products.firstIndex(where: { $0.id == product.id }) {
                        state.products.remove(at: index)
                        state.totalPrice = totalPrice(state.products)
                    }
                    return .none
                }
                
            // Empty basket actions
            case .emptyBasket(.delegate(.didAddProductsTapped)):
                return .send(.delegate(.didAddProductsTapped))
                
            // dialog actions
            case let .dialog(.presented(dialogAction)):
                switch dialogAction {                    
                case let .confirmProductDeletion(product):
                    return .send(.internal(.deleteProduct(product)), animation: .default)
                }
                
            case .path:
                return .none
                                
            case .delegate, .dialog, .emptyBasket, .topPicksBasket:
                return .none
            }
        }
        .ifLet(\.$dialog, action: /Action.dialog)
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

private extension BasketReducer {
    
    func totalPrice(_ products: [Product]) -> String {
        return products.map { $0.price }.reduce(0, +).currency()
    }
}
