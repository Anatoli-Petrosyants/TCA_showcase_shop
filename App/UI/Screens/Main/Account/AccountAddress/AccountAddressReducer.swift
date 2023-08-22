//
//  AccountAddressReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.08.23.
//

import SwiftUI
import ComposableArchitecture

struct AccountAddressReducer: Reducer {
    
    struct State: Equatable {
        var input = SearchInputReducer.State(placeholder: "Search address")
        var data: Loadable<[Place]> = .idle
    }
    
    enum Action: Equatable {
        case onViewAppear
        case onItemTap(city: String)
        
        case input(SearchInputReducer.Action)
        
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
        Scope(state: \.input, action: /Action.input) {
            SearchInputReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                state.input.isLoading = true
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
                    state.input.isLoading = false
                    state.data = .loaded(data)
                    // state.places.append(contentsOf: data)
                    return .none

                case let .placesResponse(.failure(error)):                    
                    state.input.isLoading = false
                    state.data = .failed(error)
                    return .none
                }
                
            case let .input(inputAction):
                switch inputAction {
                case let .delegate(.didSearchQueryChanged(query)):
                    Log.debug("didSearchQueryChanged \(query)")
                    return .none

                case .delegate(.didSearchQueryCleared):
                    Log.debug("didSearchQueryCleared")
                    return .cancel(id: CancelID.places)
                    
                default:
                    return .none
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
