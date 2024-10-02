//
//  Showcase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import SwiftUI
import ComposableArchitecture
import XCTestDynamicOverlay
import SwiftData

@main
struct Showcase: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @Dependency(\.swiftDataClient) var swiftDataClient
    
    var modelContext: ModelContext {
        guard let modelContext = try? self.swiftDataClient.context() else {
            fatalError("Could not find modelcontext")
        }
        return modelContext
    }
    
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                AppView(store: self.appDelegate.store)
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            self.appDelegate.store.send(.didChangeScenePhase(newPhase))
        }
        .modelContext(self.modelContext)
    }
}
