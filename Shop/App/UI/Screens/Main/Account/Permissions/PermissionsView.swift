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
    let store: StoreOf<PermissionsFeature>
}

// MARK: - Views

extension PermissionsView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }, send: { .view($0) }) { viewStore in
            VStack(spacing: 8) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 60))
                
                Text(viewStore.title)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .font(.title1)
                    .padding(.top, 24)
                
                Text(viewStore.message)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .font(.body)
                
                Button(viewStore.buttonTitle, action: {
                    viewStore.send(.onRequestNotificationsPermissionTap)
                })
                .buttonStyle(.cta)
                .padding(.top, 40)
            }
            .padding()
        }
    }
}
