//
//  Onboarding.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

struct Onboarding: Hashable, Identifiable {
    enum Tab {
        case page1, page2, page3
    }

    let id: Int
    let lottie: String
    let title: String
    let description: String
    let tab: Tab
}

extension Onboarding {

    static let pages: [Onboarding] = [
        Onboarding(id: 0,
                   lottie: "onboarding_1",
                   title: "Get healthy and live peacfully",
                   description: "Living a happier, more satisfied life is within reach.",
                   tab: .page1),
        
        Onboarding(id: 1,
                   lottie: "onboarding_2",
                   title: "Predict weather",
                   description: "Predict weather trends and conditions with current solar activity.",
                   tab: .page2),
        
        Onboarding(id: 2,
                   lottie: "onboarding_3",
                   title: "Get air quality information",
                   description: "Immediate, accurate air quality data to help you create healthier.",
                   tab: .page3),
    ]
}

