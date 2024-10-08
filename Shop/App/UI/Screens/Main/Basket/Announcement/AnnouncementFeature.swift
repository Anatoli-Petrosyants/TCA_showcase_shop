//
//  Announcement.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.07.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AnnouncementFeature {
    
    @ObservableState
    struct State {
        var url = URL(string: "https://picsum.photos/id/\(Int.random(in: 1..<50))/600/400")!
    }
    
    enum Action: Equatable {
        case onViewAppear
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none
            }
        }
    }
}
