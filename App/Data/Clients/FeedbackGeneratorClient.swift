//
//  FeedbackGeneratorClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.06.23.
//

import UIKit
import Dependencies

struct FeedbackGeneratorClient {
    var prepare: @Sendable () async -> Void
    var selectionChanged: @Sendable () async -> Void
}

extension DependencyValues {
    var feedbackGenerator: FeedbackGeneratorClient {
        get { self[FeedbackGeneratorClient.self] }
        set { self[FeedbackGeneratorClient.self] = newValue }
    }
}

extension FeedbackGeneratorClient: DependencyKey {
    static let liveValue = {
        let generator = UISelectionFeedbackGenerator()
        return Self(
            prepare: { await generator.prepare() },
            selectionChanged: { await generator.selectionChanged() }
        )
    }()
}
