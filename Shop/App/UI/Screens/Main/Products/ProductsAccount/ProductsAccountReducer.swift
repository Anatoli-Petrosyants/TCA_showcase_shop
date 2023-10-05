//
//  ProductsAccountReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct ProductsAccountReducer: Reducer {
    
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
    
    @Dependency(\.userKeychainClient) var userKeychainClient
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onViewLoad:
                    return .run { send in
                        guard let token = self.userKeychainClient.retrieveToken() else {
                            return
                        }
                        
                        let accountsStream: AsyncStream<[Account]> = databaseClient.observe(
                            Account.all
                                .where(\Account.token == token)
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
                    Log.debug("accountResponse: \(error)")
                    return .none
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
