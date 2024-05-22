//
//  ForgotPasswordView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 21.06.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ForgotPasswordView

struct ForgotPasswordView {
    @Bindable var store: StoreOf<ForgotPasswordFeature>
}

// MARK: - Views

extension ForgotPasswordView: View {
    
    var body: some View {
        content
            .navigationTitle(Localization.ForgotPassword.title)
    }
    
    @ViewBuilder private var content: some View {
        VStack {
            Spacer()

            Button(Localization.ForgotPassword.changePassword, action: {
                store.send(.view(.onChangePasswordButtonTap))
            })
            .buttonStyle(.cta)
        }
        .padding(24)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
