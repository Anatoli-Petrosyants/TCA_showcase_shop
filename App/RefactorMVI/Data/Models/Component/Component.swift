//
//  Component.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

enum ComponentType: String, Equatable {
    case locationAndMap = "location_and_map"
    case remoteImages = "remote_images"
    case navigationBar = "navigation_bar"
    case todo
    case openSafari = "open_safari"
    case onboarding
    case camera
    case userdefaults
    case unknown
}

struct Component: Hashable {
    let name: String
    let type: ComponentType
}
