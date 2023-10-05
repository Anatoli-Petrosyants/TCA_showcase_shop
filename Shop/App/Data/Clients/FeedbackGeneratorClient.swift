//
//  FeedbackGeneratorClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.06.23.
//

import UIKit
import Dependencies

/// A client for generating haptic feedback using UIKit's feedback generators.
struct FeedbackGeneratorClient {
    /// A method to prepare the feedback generator.
    var prepare: @Sendable () async -> Void
    /// A method to trigger the selection changed feedback.
    var selectionChanged: @Sendable () async -> Void
}

extension DependencyValues {
    /// Accessor for the FeedbackGeneratorClient in the dependency values.
    var feedbackGenerator: FeedbackGeneratorClient {
        get { self[FeedbackGeneratorClient.self] }
        set { self[FeedbackGeneratorClient.self] = newValue }
    }
}

extension FeedbackGeneratorClient: DependencyKey {
    /// A live implementation of FeedbackGeneratorClient.
    static let liveValue = {
        // Create an instance of UISelectionFeedbackGenerator.
        let generator = UISelectionFeedbackGenerator()
        return Self(
            prepare: { await generator.prepare() },
            selectionChanged: { await generator.selectionChanged() }
        )
    }()
}

