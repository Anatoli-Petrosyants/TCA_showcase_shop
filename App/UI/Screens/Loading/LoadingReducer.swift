//
//  LoadingReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.04.23.
//

import ComposableArchitecture
import SwiftUI
import Dependencies

struct LoadingReducer: Reducer {

    struct State: Equatable {
        @BindingState var progress: Double = 0.0
    }

    enum Action: Equatable {
        enum ViewAction: BindableAction, Equatable {
            case onViewAppear
            case binding(BindingAction<State>)
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
    }

    @Dependency(\.continuousClock) var clock

    var body: some ReducerOf<Self> {
        BindingReducer(action: /Action.view)

        Reduce { state, action in
            switch action {
                case let .view(viewAction):
                    switch viewAction {
                    case .onViewAppear:
                        return .send(.internal(.onProgressUpdated))

                    case .binding:
                        return .none
                    }

                case let .internal(internalAction):
                    switch internalAction {
                    case .onProgressUpdated:
                        state.progress += 0.01
                        return state.progress < 0.99
                        ? .run { send in
                            try await self.clock.sleep(for: .milliseconds(5))
                            await send(.internal(.onProgressUpdated))
                        }
                        :
                        .send(.delegate(.onLoaded))
                    }

            case .delegate:
                return .none
            }
        }
        ._printChanges()
    }
}
