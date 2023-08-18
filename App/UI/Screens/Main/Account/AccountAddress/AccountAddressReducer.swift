//
//  AccountAddressReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.08.23.
//

import SwiftUI
import ComposableArchitecture

struct AccountAddressReducer: Reducer {
    
    struct State: Equatable {
        var input = SearchInputReducer.State(placeholder: "Search address")
    }
    
    enum Action: Equatable {
        case onViewAppear
        case input(SearchInputReducer.Action)
    }
    
    private enum CancelID { case places }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.input, action: /Action.input) {
            SearchInputReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none
                
            case let .input(inputAction):
                switch inputAction {
                case let .delegate(.didSearchQueryChanged(query)):
                    Log.debug("didSearchQueryChanged \(query)")
                    return .none

                case .delegate(.didSearchQueryCleared):
                    Log.debug("didSearchQueryCleared")
                    return .cancel(id: CancelID.places)
                    
                default:
                    return .none
                }
            }
        }
    }
}
