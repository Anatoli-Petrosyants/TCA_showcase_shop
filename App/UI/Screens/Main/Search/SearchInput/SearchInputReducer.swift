//
//  SearchInputReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct SearchInputReducer: Reducer {
    
    struct State: Equatable {
        var placeholder = Localization.Search.inputPlacholder
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
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            /// view actions
            case let .onTextChanged(query):
                state.searchQuery = query
                state.isHiddenClearButton = query.isEmpty

                if query.isEmpty {
                    return .send(.internal(.cancel))
                } else {
                    return .send(.delegate(.didSearchQueryChanged(query)))
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
