//
//  ProductLink.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.06.23.
//

import SwiftUI
import ComposableArchitecture

struct ProductLink: ReducerProtocol {
    
    struct State: Equatable {
        var text: LocalizedStringKey
        var url: URL
        var isPresented: Bool = false
    }
    
    enum Action: Equatable {
        case present
        case dismiss
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .present:
                state.isPresented = true
                return .none

            case .dismiss:
                state.isPresented = false
                return .none
            }
        }
    }
}
