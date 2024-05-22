//
//  ContactsFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import SwiftUI
import ComposableArchitecture
import Contacts

@Reducer
struct ContactsFeature {
    
    @ObservableState
    struct State: Equatable {
        var data: Loadable<[Contact]> = .idle
        var isContactPresented = false
        var contactToShow: CNContact? = nil
    }
    
    enum Action: Equatable, BindableAction {
        enum ViewAction: Equatable {
            case onViewAppear
            case onAddButtonTap
            case onOpenSettingsButtonTap
            case onContactTap(Contact)
        }
        
        enum InternalAction: Equatable {
            case fetchContacts
            case contactsAuthorizationStatusResult(CNAuthorizationStatus)
            case contactsResponse(TaskResult<[Contact]>)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case binding(BindingAction<State>)
    }
        
    @Dependency(\.contactsClient) var contactsClient
    @Dependency(\.applicationClient.open) var openURL
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
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
                
            case let .onContactTap(contact):
                state.contactToShow = contact.toCNContact()
                state.isContactPresented = true
                return .none
                
            case .onOpenSettingsButtonTap:
                return .run { _ in
                        _ = await self.openURL(URL(string: UIApplication.openSettingsURLString)!, [:])
                    }
                
            case .onAddButtonTap:
                state.isContactPresented = true
                return .none
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
                
            case .binding:
                return .none
            }
        }
    }
}
