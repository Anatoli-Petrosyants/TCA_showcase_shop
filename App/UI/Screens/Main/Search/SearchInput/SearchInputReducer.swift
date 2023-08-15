//
//  SearchInputReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct SearchInputReducer: ReducerProtocol {
    
    struct State: Equatable, Hashable {
        var placeholder = "Search products"
        var searchQuery = ""
        var isHiddenClearButton = true
        var isLoading = true
    }
    
    enum Action: Equatable {
        case onTextChanged(String)
        case onClear
        
        enum InternalAction: Equatable {
            case cancel
        }
        
        enum Delegate: Equatable {
            case didSearchQueryChanged(String)
            case didSearchQueryCleared
        }
        
        case `internal`(InternalAction)
        case delegate(Delegate)
    }
    
    private enum CancelID { case search }
    
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            /// view actions
            case let .onTextChanged(query):
                state.searchQuery = query
                state.isHiddenClearButton = query.isEmpty
                
                if query.isEmpty {
                    return .send(.internal(.cancel))
                } else {
                    return EffectTask(value: .delegate(.didSearchQueryChanged(query)))
                        .debounce(id: CancelID.search, for: 0.5, scheduler: self.mainQueue)
                }
                
            case .onClear:
                state.searchQuery = ""
                state.isHiddenClearButton = true
                return .send(.internal(.cancel))
                
            /// internal actions
            case .internal(.cancel):
                return .concatenate([
                    .cancel(id: CancelID.search),
                    .send(.delegate(.didSearchQueryCleared))
                ])
                
            case .delegate:
                return .none
            }
        }
    }
}
