//
//  ContactsReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import SwiftUI
import ComposableArchitecture

struct ContactsReducer: Reducer {
    
    struct State: Equatable {
        var contactsError: AppError? = nil
    }
    
    enum Action: Equatable {
        case onViewAppear
    }
    
    @Dependency(\.contactsClient) var contactsClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .run { send in
                    _ = try await contactsClient.requestAccess()
                    let status = contactsClient.authorizationStatus
                    Log.debug("status \(status)")
                }
            }
        }
    }
}
