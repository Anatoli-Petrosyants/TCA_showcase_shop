//
//  CitiesFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.08.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CitiesFeature {
    
    @ObservableState
    struct State: Equatable {
        var selectedCity: String
        var data: Loadable<[Place]> = .idle
    }
    
    enum Action: Equatable {
        case onViewAppear
        case onItemTap(city: String)
        
        enum InternalAction: Equatable {
            case placesResponse(TaskResult<[Place]>)
        }
        
        enum Delegate: Equatable {
            case didCitySelected(String)
        }
        
        case `internal`(InternalAction)
        case delegate(Delegate)
    }
    
    private enum CancelID { case places }
    
    @Dependency(\.firestoreClient) var firestoreClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                state.data = .loading
                return .run { send in
                    await send(
                        .internal(
                            .placesResponse(
                                await TaskResult {
                                    try await self.firestoreClient.places()
                                }
                            )
                        ),
                        animation: .default
                    )
                }
                .cancellable(id: CancelID.places)
                
            case let .onItemTap(city):
                return .concatenate(
                    .send(.delegate(.didCitySelected(city))),
                    .run { _ in await self.dismiss() }
                )
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .placesResponse(.success(data)):
                    state.data = .loaded(data)
                    return .none

                case let .placesResponse(.failure(error)):
                    state.data = .failed(error)
                    return .none
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
