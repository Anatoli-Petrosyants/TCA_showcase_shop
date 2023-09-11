//
//  ContactsReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import SwiftUI
import ComposableArchitecture
import Contacts

struct ContactsReducer: Reducer {
    
    struct State: Equatable {        
        var data: Loadable<[Contact]> = .idle
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onViewAppear
            case onDone
            case onOpenSettings
        }
        
        enum InternalAction: Equatable {
            case fetchContacts
            case contactsAuthorizationStatusResult(CNAuthorizationStatus)
            case contactsResponse(TaskResult<[Contact]>)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
    }
        
    @Dependency(\.contactsClient) var contactsClient
    @Dependency(\.applicationClient.open) var openURL
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
            switch viewAction {
            case .onViewAppear:
                state.data = .loading
                return .run { send in
                    await send(.internal(
                        .contactsAuthorizationStatusResult(self.contactsClient.authorizationStatus))
                    )
                }
                
            case .onOpenSettings:
                return .run { _ in
                        _ = await self.openURL(URL(string: UIApplication.openSettingsURLString)!, [:])
                    }
                
            case .onDone:
                return .run { _ in await self.dismiss() }
            }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .contactsAuthorizationStatusResult(status):
                    switch status {
                    case .denied:
                        state.data = .failed(AppError.general)
                        return .none
                        
                    case .notDetermined:
                        return .run { send in
                            _ = try await self.contactsClient.requestAccess()
                            await send(.internal(.fetchContacts))
                        }
                        
                    case .authorized:
                        return .send(.internal(.fetchContacts))
                        
                    default:
                        return .none
                    }
                    
                case .fetchContacts:
                    return .run { send in
                        await send(
                            .internal(
                                .contactsResponse(
                                    await TaskResult {
                                        try await self.contactsClient.contacts()
                                    }
                                )
                            ),
                            animation: .default
                        )
                    }
                    
                case let .contactsResponse(.success(data)):
                    state.data = .loaded(data)
                    return .none

                case let .contactsResponse(.failure(error)):
                    state.data = .failed(error)
                    return .none
                }
            }
        }
    }
}
