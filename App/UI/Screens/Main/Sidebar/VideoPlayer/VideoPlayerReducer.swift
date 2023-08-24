//
//  VideoPlayerReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.08.23.
//

import SwiftUI
import ComposableArchitecture

struct VideoPlayerReducer: Reducer {
    
    struct State: Equatable, Hashable {
        
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
