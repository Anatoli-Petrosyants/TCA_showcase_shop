//
//  PhoneOTPReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.08.23.
//

import SwiftUI
import ComposableArchitecture

struct PhoneOTPReducer: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case onViewAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none
            }
        }
    }
}
