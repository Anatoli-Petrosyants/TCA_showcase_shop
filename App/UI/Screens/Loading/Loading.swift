//
//  Loading.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.04.23.
//

import ComposableArchitecture
import SwiftUI
import Dependencies

struct Loading: ReducerProtocol {
    
    struct State: Equatable {
        @BindingState var progress: Double = 0.0
    }
    
    enum Action: BindableAction, Equatable {
        enum ViewAction: Equatable {
            case onViewAppear
        }
        
        enum InternalAction: Equatable {
            case onProgressUpdated
        }
        
        enum Delegate: Equatable {
            case onLoaded
        }
        
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case binding(BindingAction<State>)
    }

    @Dependency(\.continuousClock) var clock

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                case let .view(viewAction):
                    switch viewAction {
                    case .onViewAppear:
                        return .task {
                            return .internal(.onProgressUpdated)
                        }
                    }
                    
                case let .internal(internalAction):
                    switch internalAction {
                    case .onProgressUpdated:
                        state.progress += 0.01                        
                        return state.progress < 0.99
                        ? .task {
                            try await self.clock.sleep(for: .milliseconds(5))
                            return .internal(.onProgressUpdated)
                        }
                        : .task {
                            return .delegate(.onLoaded)
                        }
                    }
                    
                case .delegate, .binding:
                    return .none
            }
        }
    }
}
