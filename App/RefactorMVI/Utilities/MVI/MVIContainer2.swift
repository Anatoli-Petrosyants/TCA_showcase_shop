//
//  MVIContainer2.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.03.23.
//

import SwiftUI
import Combine

final class MVIContainer2<Intent, Model>: ObservableObject {

    // MARK: Public

    let intent: Intent
    let model: Model

    // MARK: private

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Life cycle

    init(intent: Intent, model: Model, modelChangePublisher: ObjectWillChangePublisher) {
        self.intent = intent
        self.model = model

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
