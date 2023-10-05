//
//  DevelopedByFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.04.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct DevelopedByFeature: Reducer {

    struct State: Equatable {
        var text: String = ""
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onViewAppear
            case onAcceptTap
        }
        
        enum Delegate: Equatable {
            case didDevelopedByViewed
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
                    state.text = Constant.aboutMe
                    return .none
                    
                case .onAcceptTap:
                    return .concatenate(
                        .send(.delegate(.didDevelopedByViewed)),
                        .run { _ in await self.dismiss() }
                    )
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
