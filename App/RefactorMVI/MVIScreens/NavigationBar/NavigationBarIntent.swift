//
//  NavigationBarIntent.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.03.23.
//

import Foundation

protocol NavigationBarIntentType {
    typealias State = NavigationBarModel.State
    typealias Action = NavigationBarModel.Action

    var state: State { get }
    func execute(action: Action)
}

final class NavigationBarIntent: ObservableObject, NavigationBarIntentType, IntentType {

    // MARK: Output
    @Published
    var state: State = .init(navigationTitle: "navigation.bar.title",
                             cancelButtonTitle: "navigation.bar.cancel.button.title",
                             showInfoAlert: false,
                             showAddAlert: false,
                             showActionSheet: false)
    
    // MARK: Input
    func mutate(action: Action) {
        switch action {
        case .onViewApear:
            processViewOnApear()
        case .onInfoButtonTap:
            state.showInfoAlert = true
        case .onAddButtonTap:
            state.showAddAlert = true
        case .onTrashButtonTap:
            state.showActionSheet = true
        }
    }
}

// MARK: Actions

private extension NavigationBarIntent {
    
    func processViewOnApear() {
        
    }
}

