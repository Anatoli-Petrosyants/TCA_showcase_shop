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
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack(alignment: .center) {
                    if viewStore.items.isEmpty {
                        ContentUnavailableView {
                            Label("You don't have any notifications.", systemImage: "bell.fill")
                                .font(.title2)
                                .foregroundColor(Color.black)
                        }
                    } else {
                        List(viewStore.items, id: \.id) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(item.title)")
                                    .font(.bodyBold)

                                Text("\(item.description)")
                                    .font(.footnote)
                                    .foregroundColor(Color.black05)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewStore.send(.view(.onNotificationTap(notification: item)))
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button("Mark as read") {
                                    viewStore.send(.view(.onNotificationTap(notification: item)))
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
                .navigationTitle("Notifications (\(viewStore.items.count))")
            }
            .badge(viewStore.items.count)
            .alert(store: self.store.scope(state: \.$alert, action: NotificationsFeature.Action.alert))
        }
    }
}
