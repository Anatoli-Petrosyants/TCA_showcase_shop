//
//  Onboarding.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

struct Onboarding: Hashable, Identifiable {
    enum Tab: CaseIterable {
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
                   title: "Lorem Ipsum is simply dummy text 1",
                   description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                   tab: .page1),
        
        Onboarding(id: 1,
                   lottie: "onboarding_2",
                   title: "Lorem Ipsum is simply dummy text 2",
                   description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                   tab: .page2),
        
        Onboarding(id: 2,
                   lottie: "onboarding_3",
                   title: "Lorem Ipsum is simply dummy text 3",
                   description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                   tab: .page3),
    ]
}

