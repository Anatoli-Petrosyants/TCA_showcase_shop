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
        var totalPrice: String = "$0.00"
        
        @PresentationState var dialog: ConfirmationDialogState<Action.DialogAction>?
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
            case confirmProductsCheckout
            case confirmProductDeletion(Product)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case dialog(PresentationAction<DialogAction>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onViewAppear:
                    state.totalPrice = totalPrice(state.products)
                    return .none
                    
                case .onProceedToCheckoutButtonTap:
                    state.dialog = ConfirmationDialogState {
                        TextState("Confirmation dialog")
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState("Cancel")
                        }
                        ButtonState(action: .confirmProductsCheckout) {
                            TextState("Checkout")
                        }
                    } message: {
                        TextState("This is a confirmation dialog.")
                    }
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
                
            // dialog actions
            case let .dialog(.presented(dialogAction)):
                switch dialogAction {
                case .confirmProductsCheckout:
                    state.products.removeAll()
                    state.totalPrice = "$0.00"
                    return .none
                    
                case let .confirmProductDeletion(product):
                    return .send(.internal(.deleteProduct(product)), animation: .default)
                }
                                
            case .delegate, .dialog:
                return .none
            }
        }
        .ifLet(\.$dialog, action: /Action.dialog)
    }
}

private extension BasketReducer {
    
    func totalPrice(_ products: [Product]) -> String {
        return products.map { $0.price }.reduce(0, +).currency()
    }
}
