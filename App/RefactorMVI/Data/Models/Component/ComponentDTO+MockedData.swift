//
//  ComponentDTO+MockedData.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

#if DEBUG

extension ComponentDTO {

    static let mockedData: [ComponentDTO] = [
        ComponentDTO(name: "Camera", type: "camera"),
        ComponentDTO(name: "Onboarding", type: "onboarding"),
        ComponentDTO(name: "Open Safari", type: "open_safari"),
        ComponentDTO(name: "Todos", type: "todo"),
        ComponentDTO(name: "Location and map", type: "location_and_map"),
        ComponentDTO(name: "Remote images", type: "remote_images"),
        ComponentDTO(name: "Navigation Bar", type: "navigation_bar"),
        ComponentDTO(name: "UserDefaults", type: "userdefaults"),        
        ComponentDTO(name: "Collection List", type: "remote_images"),
        ComponentDTO(name: "ScrollView with StackView", type: "remote_images"),
        ComponentDTO(name: nil, type: nil),
        ComponentDTO(name: "Tab Bar", type: "remote_images")
    ]
}

#endif
