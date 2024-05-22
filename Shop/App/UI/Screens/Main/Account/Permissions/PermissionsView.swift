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
        VStack(spacing: 8) {
            Image(systemName: "bell.badge")
                .font(.system(size: 60))
            
            Text(store.title)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .font(.title1)
                .padding(.top, 24)
            
            Text(store.message)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .font(.body)
            
            Button(store.buttonTitle, action: {
                store.send(.view(.onRequestNotificationsPermissionTap))
            })
            .buttonStyle(.cta)
            .padding(.top, 40)
        }
        .padding()
    }
}
