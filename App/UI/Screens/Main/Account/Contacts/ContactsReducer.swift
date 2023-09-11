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
        
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onViewAppear
        }
        
        enum InternalAction: Equatable {
            case requestContactsPermission
            case contactsAuthorizationStatusResult(CNAuthorizationStatus)
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
                return .run { send in
                    await send(.internal(
                        .contactsAuthorizationStatusResult(self.contactsClient.authorizationStatus))
                    )
                }
            }
                
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case let .contactsAuthorizationStatusResult(status):
                    switch status {
                    case .denied:
                        Log.info("show open settings button")
                        return .none
                        
                    case .notDetermined:
                        return .send(.internal(.requestContactsPermission))
                        
                    default:
                        return .none
                    }
                    
                case .requestContactsPermission:
                    return .run { _ in
                        do {
                            _ = try await self.contactsClient.requestAccess()
                            let contacts = try await self.contactsClient.contacts()
                            Log.debug("contacts \(contacts)")
                        } catch {
                            Log.error("requestContactsPermission error: \(error)")
                        }
                    }
                }
            }
        }
    }
}
