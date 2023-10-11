//
//  BasketFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.06.23.
//

import SwiftUI
import ComposableArchitecture

struct BasketFeature: Reducer {
    
    struct State: Equatable {
        var products: [Product] = []
        var topPicksProducts: [Product] = []
        var totalPrice: String = "$0.00"
        var addProduct = AddProductFeature.State()
        var announcement = AnnouncementFeature.State()
        var topPicks = TopPicksFeature.State()
        
        @BindingState var toastMessage: LocalizedStringKey? = nil
        @PresentationState var dialog: ConfirmationDialogState<Action.DialogAction>?
        var path = StackState<Path.State>()
    }
    
    enum Action: Equatable {
        enum ViewAction: BindableAction, Equatable {
            case onViewAppear
            case onDeleteItemButtonTap(Product)
            case onProceedToCheckoutButtonTap
            case binding(BindingAction<State>)
        }
        
        enum InternalAction: Equatable {
            case deleteProduct(Product)
        }
        
        enum Delegate: Equatable {
            case didAddProductsTapped
            case didTopPickAddedToBasket(Product)
            case didSuccessfullyCheckoutProducts
        }
        
        enum DialogAction: Equatable {
            case confirmProductDeletion(Product)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case addProduct(AddProductFeature.Action)
        case announcement(AnnouncementFeature.Action)
        case topPicks(TopPicksFeature.Action)
        case dialog(PresentationAction<DialogAction>)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case checkout(CheckoutFeature.State)
            case details(ProductDetailFeature.State)
        }

        enum Action: Equatable {
            case checkout(CheckoutFeature.Action)
            case details(ProductDetailFeature.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: /State.checkout, action: /Action.checkout) {
                CheckoutFeature()
            }
            
            Scope(state: /State.details, action: /Action.details) {
                ProductDetailFeature()
            }
        }
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: /Action.view)
        
        Scope(state: \.addProduct, action: /Action.addProduct) {
            AddProductFeature()
        }
        
        Scope(state: \.announcement, action: /Action.announcement) {
            AnnouncementFeature()
        }
        
        Scope(state: \.topPicks, action: /Action.topPicks) {
            TopPicksFeature()
        }
        
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onViewAppear:
                    state.totalPrice = totalPrice(state.products)
                    state.topPicks.products = state.topPicksProducts
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
                    
                case .binding:
                    return .none
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
            case .addProduct(.delegate(.didAddProductsTapped)):
                return .send(.delegate(.didAddProductsTapped))
                
            // dialog actions
            case let .dialog(.presented(dialogAction)):
                switch dialogAction {                    
                case let .confirmProductDeletion(product):
                    return .send(.internal(.deleteProduct(product)), animation: .default)
                }
                
            // path actions
            case let .path(pathAction):
                switch pathAction {
                case .element(id: _, action: .checkout(.delegate(.didCheckoutCompleted))):
                    state.toastMessage = Localization.Base.successfullySaved
                    state.products.removeAll()
                    state.totalPrice = ""
                    return .send(.delegate(.didSuccessfullyCheckoutProducts))
                    
                case let .element(id: _, action: .details(.delegate(.didProductAddedToBasket(product)))):
                    return .concatenate(
                        .send(.delegate(.didTopPickAddedToBasket(product))),
                        .send(.view(.onViewAppear))
                    )
                    
                default:
                    return .none
                }
                
            case let .topPicks(.delegate(.didItemSelected(product))):
                state.path.append(.details(.init(id: self.uuid(), product: product)))
                return .none
                
            case .delegate, .dialog, .addProduct, .announcement, .topPicks:
                return .none
            }
        }
        .ifLet(\.$dialog, action: /Action.dialog)
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

private extension BasketFeature {
    
    func totalPrice(_ products: [Product]) -> String {
        return products.map { $0.price }.reduce(0, +).currency()
    }
}
