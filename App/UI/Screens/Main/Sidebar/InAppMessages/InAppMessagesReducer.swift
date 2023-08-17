//
//  InAppMessagesReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.07.23.
//

import SwiftUI
import ComposableArchitecture

struct InAppMessagesReducer: Reducer {
    
    struct State: Equatable {
        @BindingState var isToastTopVersion1 = false
        @BindingState var isToastTopVersion2 = false
        @BindingState var isToastBottomVersion1 = false
        
        @BindingState var isPopupMiddleVersion = false
        @BindingState var isPopupBottomVersion = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
        
        BindingReducer()
    }
}
