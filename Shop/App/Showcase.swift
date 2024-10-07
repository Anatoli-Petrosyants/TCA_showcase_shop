//
//  Showcase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import SwiftUI
import ComposableArchitecture
import XCTestDynamicOverlay
import GoogleSignIn

@main
struct Showcase: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                AppView(store: self.appDelegate.store)
                    .onAppear {
                        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                            Log.debug("GIDSignIn user \(user?.profile?.email)")
                            Log.debug("GIDSignIn error \(error?.localizedDescription)")
                            
                            if error != nil || user == nil {
                              // Show the app's signed-out state.
                            } else {
                              // Show the app's signed-in state.
                            }
                        }
                    }
                    .onOpenURL { url in
                        Log.debug("URL: \(url.absoluteString)")
                        GIDSignIn.sharedInstance.handle(url)
                    }
            }
        }
        .onChange(of: scenePhase) { (phase, _) in
            self.appDelegate.store.send(.didChangeScenePhase(phase))
        }
    }
}
