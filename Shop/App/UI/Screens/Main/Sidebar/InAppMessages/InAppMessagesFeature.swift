//
//  InAppMessagesFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.07.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct InAppMessagesFeature {
    
    @ObservableState
    struct State: Equatable {
        var isToastTopVersion1 = false
        var isToastTopVersion2 = false
        var isToastBottomVersion1 = false
        
        var isPopupMiddleVersion = false
        var isPopupBottomVersion = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
