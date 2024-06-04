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
    @Bindable var store: StoreOf<NotificationsFeature>
}

// MARK: - Views

extension NotificationsView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                if store.items.isEmpty {
                    ContentUnavailableView {
                        Label("You don't have any notifications.", systemImage: "bell.fill")
                            .font(.title3)
                            .foregroundColor(Color.black)
                    }
                } else {
                    List(store.items, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(item.title)")
                                .font(.bodyBold)

                            Text("\(item.description)")
                                .font(.footnote)
                                .foregroundColor(Color.black05)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.view(.onNotificationTap(notification: item)))
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button("Mark as read") {
                                store.send(.view(.onNotificationTap(notification: item)))
                            }
                            .tint(.blue)
                        }
                    }
                    .environment(\.defaultMinListRowHeight, 54)
                    .listRowBackground(Color.clear)
                    .listStyle(.plain)
                }
            }
            .padding()
            .navigationTitle("Notifications (\(store.items.count))")
        }
        .badge(store.items.count)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
