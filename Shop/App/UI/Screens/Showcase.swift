//
//  Showcase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import SwiftUI
import ComposableArchitecture
import XCTestDynamicOverlay

@main
struct Showcase: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                AppView(store: self.appDelegate.store)
            }
        }
        .onChange(of: scenePhase) { phase in
            self.appDelegate.store.send(.didChangeScenePhase(phase))
            // self.appDelegate.store.send(.didChangeScenePhase(phase))
        }
    }
}
