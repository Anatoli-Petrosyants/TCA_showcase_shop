//
//  AccountFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import SwiftUI
import ComposableArchitecture
import CoreData

@Reducer
struct AccountFeature {
    
    enum Gender: String, CaseIterable, Equatable {
        case male
        case female
        case other
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case contacts(ContactsFeature)
        case cities(CitiesFeature)
    }
    
    @ObservableState
    struct State {
        var accountId: UUID? = nil
        let appVersion = "\(Configuration.current.appVersion)"
        let supportedVersion = "16.0"
        var notificationsPermissionStatus = ""
        
        var accountPhoto = AccountPhotoFeature.State()
        
        var firstName = ""
        var lastName = ""
        var birthDate = Date()
        var gender = Gender.male
        var enableNotifications = false
        
        var city = ""
        
        var email = ""
        var phone = ""
        
        var isPresentedBanner: Bool = false
        @Presents var dialog: ConfirmationDialogState<Action.DialogAction>?
        @Presents var permissions: PermissionsFeature.State?

        var path = StackState<Path.State>()
    }
    
    enum Action: BindableAction {
        enum ViewAction: Equatable {
            case onViewAppear
            case onCityTap
            case onSaveTap
            case onPermissionsTap
            case onContactsTap
            case onLogoutTap
        }
        
        enum DialogAction: Equatable {
            case onConfirmLogout
        }
        
        enum InternalAction: Equatable {
            case accountResponse(TaskResult<Account?>)
            case notificationPermissionsStatusResult(UNAuthorizationStatus)
            case confirmLogout
        }
        
        enum Delegate: Equatable {
            case didLogout
        }
        
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case dialog(PresentationAction<Action.DialogAction>)
        case accountPhoto(AccountPhotoFeature.Action)
        case permissions(PresentationAction<PermissionsFeature.Action>)
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
    }

    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.userKeychainClient) var userKeychainClient
    @Dependency(\.databaseClient) var databaseClient
    @Dependency(\.userNotificationClient.authorizationStatus) var authorizationStatus
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.accountPhoto, action: /Action.accountPhoto) {
            AccountPhotoFeature()
        }
        
        Reduce { state, action in
            switch action {
            // view actions
            case let .view(viewAction):
                switch viewAction {
                case .onViewAppear:
                    let request = Account.all
                        .where(\Account.token == self.userKeychainClient.retrieveToken()!)
                        .limit(1)
                    
                    return .concatenate(
                        .run { send in
                            let status = await self.authorizationStatus()
                            await send(.internal(.notificationPermissionsStatusResult(status)))
                        },
                        .run { send in
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
                    )
                    
                case .onSaveTap:                    
                    state.isPresentedBanner = true
                    
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
                    
                case .onCityTap:
                    state.path.append(.cities(.init(selectedCity: state.city)))
                    return .none
                    
                case .onPermissionsTap:
                    state.permissions = PermissionsFeature.State()
                    return .none
                    
                case .onContactsTap:
                    state.path.append(.contacts(.init()))
                    return .none
                }
               
            // internal actions
            case let .internal(internalAction):
                switch internalAction {
                case .confirmLogout:
                    userKeychainClient.removeToken()
                    return .run { send in
                        await self.userDefaultsClient.reset()
                        await send(.delegate(.didLogout))
                    }
                    
                case let .accountResponse(.success(data)):
                    if let data = data {
                        state.accountId = data.id
                        state.firstName = data.firstName
                        state.lastName = data.lastName
                        state.birthDate = data.birthDate
                        state.gender = Gender(rawValue: data.gender) ?? .other
                        state.city = data.city
                        state.email = data.email
                        state.phone = data.phone
                        state.enableNotifications = data.enableNotifications
                    }
                    return .none

                case let .accountResponse(.failure(error)):
                    Log.debug("account failure: \(error.localizedDescription)")
                    return .none
                    
                case let .notificationPermissionsStatusResult(status):
                    state.notificationsPermissionStatus = status.description
                    return .none
                }
                
            // dialog actions
            case .dialog(.presented(.onConfirmLogout)):
                return .send(.internal(.confirmLogout))

            // path actions
            case let .path(pathAction):
                switch pathAction {
                case let .element(id: _, action: .cities(.delegate(.didCitySelected(city)))):
                    state.city = city
                    return .none
                    
                default:
                    return .none
                }
        
            // account photo actions
            case let .accountPhoto(.delegate(.didPhotoSelected(image))):
                Log.debug("accountPhoto image \(image)")
                return .none
                
            case .binding, .delegate, .dialog, .permissions, .accountPhoto:
                return .none
            }
        }
        .ifLet(\.$dialog, action: /Action.dialog)
        .ifLet(\.$permissions, action: /Action.permissions) {
            PermissionsFeature()
        }
        .forEach(\.path, action: \.path)
    }
}
