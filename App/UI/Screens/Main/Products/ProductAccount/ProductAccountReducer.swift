//
//  ProductAccountReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct ProductAccountReducer: Reducer {
    
    struct State: Equatable {
        var name: String = ""
        var countryCode: String = ""
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onViewLoad
            case onTap
        }
        
        enum InternalAction: Equatable {
            case accountResponse(TaskResult<Account?>)
        }
        
        enum Delegate: Equatable {
            case didTap
        }
        
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onViewLoad:
                    return .run { send in
                        let accountsStream: AsyncStream<[Account]> = databaseClient.observe(
                            Account.all
                                .where(\Account.token == self.userDefaultsClient.token.valueOr("showcase_token"))
                                .limit(1)
                        )
                        
                        for try await account in accountsStream {
                            await send(
                                .internal(
                                    .accountResponse(
                                        await TaskResult {
                                            account.first
                                        }
                                    )
                                )
                            )
                        }
                    }
                    
                case .onTap:
                    return .send(.delegate(.didTap))
                }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .accountResponse(.success(optionalData)):
                    if let data = optionalData {
                        state.name = data.firstName
                    }
                    return .none

                case let .accountResponse(.failure(error)):
                    Log.debug("productsResponse: \(error)")
                    return .none
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
