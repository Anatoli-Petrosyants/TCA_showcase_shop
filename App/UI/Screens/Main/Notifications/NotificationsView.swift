//
//  NotificationsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 05.10.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - NotificationsFeatureView

struct NotificationsFeatureView {
    let store: StoreOf<NotificationsFeature>
}

// MARK: - Views

extension NotificationsFeatureView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Notifications Feature")
        }
    }
}
