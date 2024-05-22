//
//  NoNetwork.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

@Reducer
struct NoNetwork {

    struct State: Equatable {
    }

    enum Action: Equatable {
        case onOkTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case onRetry
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onOkTapped:
                return .concatenate(
                    .send(.delegate(.onRetry)),
                    .run { _ in await self.dismiss() }
                )
                
            case .delegate:
                return .none
            }
        }
    }
}
