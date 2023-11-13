//
//  CheckoutFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.09.23.
//

import SwiftUI
import ComposableArchitecture

struct CheckoutFeature: Reducer {

    struct State: Equatable {
        var addresses = ShipmentAddress.mockedData
        var cards = PaymentCard.mockedData
        @PresentationState var alert: AlertState<Never>?
    }
    
    enum Action: Equatable{
        enum ViewAction: Equatable {
            case onAddressChange(ShipmentAddress)
            case onCardChange(PaymentCard)
            case onCheckoutButtonTap
        }
        
        enum InternalAction: Equatable {
            case localAuthenticationResponse(TaskResult<Bool>)
        }
        
        enum Delegate: Equatable {
            case didCheckoutCompleted
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case alert(PresentationAction<Never>)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.localAuthenticationClient) var localAuthenticationClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(.onAddressChange(address)):
                for (index, value) in state.addresses.enumerated() {
                    state.addresses[index].isSelected = value.id == address.id
                }                
                return .none
                
            case let .view(.onCardChange(card)):
                for (index, value) in state.cards.enumerated() {
                    state.cards[index].isDefaultPaymentMethod = value.id == card.id
                }
                return .none
                
            case .view(.onCheckoutButtonTap):
                return .run { send in
                    await send(
                        .internal(
                            .localAuthenticationResponse(
                                await TaskResult {
                                    try await self.localAuthenticationClient.authenticate(
                                        "We need to authentication you for payment."
                                    )
                                }
                            )
                        )
                    )
                }
                
            case let .internal(internalAction):
                switch internalAction {
                case .localAuthenticationResponse(.success):
                    state.alert = AlertState(title: TextState("Congrats!"),
                                             message: TextState("You have successfully checkout products."))
                    return .none
                    
                case let .localAuthenticationResponse(.failure(error)):
                    Log.error("localAuthenticationResponse failure: \(error)")
                    return .none
                }

            case .alert(.dismiss):
                return .concatenate(
                    .send(.delegate(.didCheckoutCompleted)),
                    .run { _ in await self.dismiss() }
                )

            case .delegate, .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}
