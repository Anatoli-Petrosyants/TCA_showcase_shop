//
//  Agreements.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.04.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct Agreements: Reducer {

    struct State: Equatable {
        var text: String = ""
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onViewAppear
            case onAcceptTap
        }
        
        enum Delegate: Equatable {
            case didAgreementsAccepted
        }
        
        case view(ViewAction)
        case delegate(Delegate)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onViewAppear:
                    state.text = randomString(length: 3000)
                    return .none
                    
                case .onAcceptTap:
                    return .concatenate(
                        .send(.delegate(.didAgreementsAccepted)),
                        .run { _ in await self.dismiss() }
                    )
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
