//
//  Localization+Sidebar.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 16.08.23.
//

import SwiftUI

extension Localization {
    enum Sidebar {
        static var title: LocalizedStringKey { return "sidebar.title" }
        static var healthKit: LocalizedStringKey { return "sidebar.item.healthKit" }
        static var camera: LocalizedStringKey { return "sidebar.item.camera" }
        static var chooseCountry: LocalizedStringKey { return "sidebar.item.chooseCountry" }
        static var map: LocalizedStringKey { return "sidebar.item.map" }
        static var inAppMessages: LocalizedStringKey { return "sidebar.item.inAppMessages" }
        static var darkMode: LocalizedStringKey { return "sidebar.item.darkMode" }
        static var shareApp: LocalizedStringKey { return "sidebar.item.shareApp" }
        static var appSettings: LocalizedStringKey { return "sidebar.item.appSettings" }
        static var rateUs: LocalizedStringKey { return "sidebar.item.rateUs" }
        static var contactUs: LocalizedStringKey { return "sidebar.item.contactUs" }
        static var videoPlayer: LocalizedStringKey { return "sidebar.item.videoPlayer" }        
    }
}
