//
//  LoadingFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.04.23.
//

import ComposableArchitecture
import SwiftUI
import Dependencies

@Reducer
struct LoadingFeature {

    @ObservableState
    struct State: Equatable {
        var progress: Double = 0.0
    }

    enum Action: Equatable, BindableAction {
        enum ViewAction: Equatable {
            case onViewAppear
            case onDisappear
        }

        enum InternalAction: Equatable {
            case onProgressStart
            case onProgressUpdated
            case onProgressEnd
        }

        enum Delegate: Equatable {
            case didLoaded
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }

    @Dependency(\.continuousClock) var clock

    private enum CancelID { case timer }
    
    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
                case let .view(viewAction):
                    switch viewAction {
                    case .onViewAppear:
                        return .send(.internal(.onProgressStart))
                        
                    case .onDisappear:
                      return .cancel(id: CancelID.timer)
                    }

                case let .internal(internalAction):
                    switch internalAction {
                    case .onProgressStart:
                        return .run { send in
                            for await _ in self.clock.timer(interval: .milliseconds(10)) {
                                await send(.internal(.onProgressUpdated),
                                           animation: .interpolatingSpring(stiffness: 3000, damping: 40))
                            }
                        }
                        .cancellable(id: CancelID.timer, cancelInFlight: true)

                    case .onProgressUpdated:
                        state.progress += 0.01
                        return state.progress < 1 ? .none : .send(.internal(.onProgressEnd))
                        
                    case .onProgressEnd:
                        return .concatenate(
                            .cancel(id: CancelID.timer),
                            .send(.delegate(.didLoaded))
                        )
                    }
                
            case .binding:
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
