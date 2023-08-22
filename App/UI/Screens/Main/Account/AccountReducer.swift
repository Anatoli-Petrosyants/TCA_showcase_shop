//
//  AccountReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import SwiftUI
import ComposableArchitecture
import CoreData

struct AccountReducer: Reducer {
    
    enum Gender: String, CaseIterable, Equatable {
        case male
        case female
        case other
    }
    
    struct State: Equatable {
        var accountId: UUID? = nil
        var appVersion = "\(Configuration.current.appVersion)"
        var supportedVersion = "16.0"
        
        @BindingState var firstName = ""
        @BindingState var lastName = ""
        @BindingState var birthDate = Date()
        @BindingState var gender = Gender.male
        @BindingState var enableNotifications = true
        
        var city = "Choose City"
        
        @BindingState var email = ""
        @BindingState var phone = ""
        
        @BindingState var toastMessage: LocalizedStringKey? = nil
        @PresentationState var dialog: ConfirmationDialogState<Action.DialogAction>?
        
        @PresentationState var address: AccountCitiesReducer.State?
    }
    
    enum Action: Equatable {
        enum ViewAction:  BindableAction, Equatable {
            case onViewLoad
            case onAddressTap
            case onSaveTap
            case onLogoutTap
            case binding(BindingAction<State>)
        }
        
        enum DialogAction: Equatable {
            case onConfirmLogout
        }
        
        enum InternalAction: Equatable {
            case accountResponse(TaskResult<Account?>)
            case confirmLogout
        }
        
        enum Delegate: Equatable {
            case didLogout
        }
        
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case dialog(PresentationAction<Action.DialogAction>)
        case address(PresentationAction<AccountCitiesReducer.Action>)
    }
    
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: /Action.view)
        
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onViewLoad:
                    let request = Account.all
                        .where(\Account.token == self.userDefaults.token!)
                        .limit(1)

                    return .run { send in
                        await send(
                            .internal(
                                .accountResponse(
                                    await TaskResult {
                                        try await self.databaseClient.fetch(request).first
                                    }
                                )
                            )
                        )
                    }
                    
                case .onSaveTap:
                    state.toastMessage = Localization.Base.successfullySaved
                    
                    return .run { [id = state.accountId,
                                   firstName = state.firstName,
                                   lastName = state.lastName,
                                   birthDate = state.birthDate,
                                   gender = state.gender,
                                   city = state.city,
                                   email = state.email,
                                   phone = state.phone,
                                   enableNotifications = state.enableNotifications
                    ] _ in
                        try await databaseClient.update(id!, \Account.firstName, firstName)
                        try await databaseClient.update(id!, \Account.lastName, lastName)
                        try await databaseClient.update(id!, \Account.birthDate, birthDate)
                        try await databaseClient.update(id!, \Account.gender, gender.rawValue)
                        try await databaseClient.update(id!, \Account.city, city)
                        try await databaseClient.update(id!, \Account.email, email)
                        try await databaseClient.update(id!, \Account.phone, phone)
                        try await databaseClient.update(id!, \Account.enableNotifications, enableNotifications)
                    }
                    
                case .onLogoutTap:
                    state.dialog = ConfirmationDialogState {
                        TextState(Localization.Base.attention)
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState(Localization.Base.cancel)
                        }
                        ButtonState(role: .destructive, action: .onConfirmLogout) {
                            TextState(Localization.Base.logout)
                        }
                    } message: {
                        TextState(Localization.Base.areYouSure)
                    }

                    return .none
                    
                case .onAddressTap:
                    state.address = AccountCitiesReducer.State()
                    return .none
                    
                case .binding:
                    return .none
                }
               
                // internal actions
                case let .internal(internalAction):
                    switch internalAction {
                    case .confirmLogout:
                        return .run { send in
                            await self.userDefaults.reset()
                            await send(.delegate(.didLogout))
                        }
                        
                    case let .accountResponse(.success(data)):
                        state.accountId = data?.id
                        state.firstName = data?.firstName ?? ""
                        state.lastName = data?.lastName ?? ""
                        state.birthDate = data?.birthDate ?? Date()
                        state.gender = Gender(rawValue: data?.gender ?? "") ?? .other
                        state.city = data?.city ?? ""
                        state.email = data?.email ?? ""
                        state.phone = data?.phone ?? ""
                        state.enableNotifications = data?.enableNotifications ?? false
                        return .none

                    case let .accountResponse(.failure(error)):
                        Log.debug("account failure: \(error.localizedDescription)")
                        return .none
                    }
                
                // dialog actions
                case .dialog(.presented(.onConfirmLogout)):
                    return .send(.internal(.confirmLogout))
            
            case let .address(.presented(.delegate(.didCitySelected(city)))):
                state.city = city
                return .none
                
            case .delegate, .dialog, .address:
                return .none
            }
        }
        .ifLet(\.$dialog, action: /Action.dialog)
        .ifLet(\.$address, action: /Action.address) { AccountCitiesReducer() }
    }    
}
