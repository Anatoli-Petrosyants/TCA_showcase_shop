//
//  MVIContainer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 01.03.23.
//

import SwiftUI
import Combine

final class MVIContainer<Intent, State>: ObservableObject {

    // MARK: Public

    let intent: Intent
    let state: State

    // MARK: private

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Life cycle

    init(intent: Intent, state: State, modelChangePublisher: ObjectWillChangePublisher) {
        self.intent = intent
        self.state = state

        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellable)
        
        Log.initOf(self)
    }
    
    deinit {
        Log.deinitOf(self)
    }
}

