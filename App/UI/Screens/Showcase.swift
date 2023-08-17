//
//  Showcase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import SwiftUI
import ComposableArchitecture

@main
struct Showcase: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
//            let store = Store(
//                initialState: BasketReducer.State(
//                    products: ProductDTO.mockedData.map { $0.toEntity() }
//                ),
//                reducer: BasketReducer()
//            )
//            BasketView(store: store)
            
//            let store = Store(
//                initialState: ProductDetails.State(id: UUID(),
//                                                   product: ProductDTO.mockedData.map { $0.toEntity() }.first!),
//                reducer: ProductDetails()
//            )
//            ProductDetailsView(store: store)
            
            AppView(store: self.appDelegate.store)
        }
        .onChange(of: scenePhase) { phase in
            self.appDelegate.store.send(.didChangeScenePhase(phase))
        }
    }
}
