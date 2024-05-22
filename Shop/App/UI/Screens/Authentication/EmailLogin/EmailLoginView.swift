//
//  LoginView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - LoginView

struct EmailLoginView {
    @Bindable var store: StoreOf<EmailLoginFeature>
}

// MARK: - Views

extension EmailLoginView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        BlurredActivityIndicatorView(
            isShowing: $store.isActivityIndicatorVisible)
        {
            VStack {
                VStack {
                    TextField(
                        Localization.Base.emailPlaceholder,
                        text: $store.username
                    )
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textFieldStyle(.main)
                    
                    SecureField(
                        "••••••••",
                        text: $store.password
                    )
                    .textFieldStyle(.main)
                    
                    HStack {
                        Spacer()
                        Button(Localization.Login.forgotPassword, action: {
                            store.send(.view(.onForgotPasswordButtonTap))
                        })
                        .buttonStyle(.linkButton)
                    }
                    .padding(.top, 16)
                    
                    Button(Localization.Base.continue, action: {
                        store.send(.view(.onSignInButtonTap))
                    })
                    .buttonStyle(.cta)
                    .padding(.top, 24)
                }
                .padding(24)
                
                Spacer()
            }
            .navigationTitle(Localization.Login.title)
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
