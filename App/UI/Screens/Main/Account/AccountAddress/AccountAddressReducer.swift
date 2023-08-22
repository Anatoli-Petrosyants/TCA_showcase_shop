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
        var places: [Place] = []
    }
    
    enum Action: Equatable {
        case onViewAppear
        case input(SearchInputReducer.Action)
        
        enum InternalAction: Equatable {
            case placesResponse(TaskResult<[Place]>)
        }
        
        case `internal`(InternalAction)
    }
    
    private enum CancelID { case places }
    
    @Dependency(\.firestoreClient) var firestoreClient
    
    var body: some ReducerOf<Self> {
        Scope(state: \.input, action: /Action.input) {
            SearchInputReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                state.input.isLoading = true
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
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .placesResponse(.success(data)):
                    Log.debug("places \(data)")
                    
                    state.input.isLoading = false
                    state.places.append(contentsOf: data)
                    return .none

                case let .placesResponse(.failure(error)):
                    Log.debug("account failure: \(error.localizedDescription)")
                    state.input.isLoading = false
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
            }
        }
    }
}
