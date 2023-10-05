//
//  NotificationsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 05.10.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - NotificationsFeatureView

struct NotificationsView {
    let store: StoreOf<NotificationsFeature>
}

// MARK: - Views

extension NotificationsView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack(alignment: .center) {
                    if viewStore.notifications.isEmpty {
                        NotificationsEmptyView()
                    } else {
                        
                    }
                }
                .padding()
                .navigationTitle("Notifications (\(viewStore.notifications.count))")
            }
            .badge(viewStore.notifications.count)
        }
    }
}

struct NotificationsEmptyView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "bell.fill")
                .font(.system(size: 60))
            
            Text("You don't have any notifications.")
                .font(.title2)
                .multilineTextAlignment(.center)
        }
    }
}
