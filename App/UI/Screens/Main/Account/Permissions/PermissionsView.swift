//
//  PermissionsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.09.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - PermissionsView

struct PermissionsView {
    let store: StoreOf<PermissionsReducer>
}

// MARK: - Views

extension PermissionsView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }, send: { .view($0) }) { viewStore in
            VStack(spacing: 24) {
                Text("Permissions")
                
                Button("Check Status", action: {
                    viewStore.send(.onNotificationsTap)
                })
                .buttonStyle(.cta)
                
                Button("Request Permissions", action: {
                    viewStore.send(.onRequestNotificationsPermissionTap)
                })
                .buttonStyle(.cta)
            }
            .padding()
        }
    }
}
