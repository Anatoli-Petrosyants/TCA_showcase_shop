//
//  LoginOptionsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.08.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - LoginOptionsView

struct JoinView {
    @Bindable var store: StoreOf<JoinFeature>
}

// MARK: - Views

extension JoinView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                Spacer()
                
                Image(systemName: "pencil.slash")
                    .font(.system(size: 100))

                VStack(spacing: 6) {
                    Text(Localization.LoginOptions.description)
                        .multilineTextAlignment(.center)
                        .font(.headline)

                    Button {
                        store.send(.view(.onDevelopedByTap))
                    } label: {
                        Text("Anatoli Petrosyants")
                            .font(.headlineBold)
                            .foregroundColor(.black)
                            .underline()
                    }
                }
                .padding(.top, 24)
                
                Spacer()
                
                Button("Join", action: {
                    store.send(.view(.onJoinButtonTap))
                })
                .buttonStyle(.cta)
            }
            .padding(24)
            .navigationTitle(Localization.LoginOptions.title)
            .modifier(NavigationBarModifier())
        } destination: { store in
            switch store.case {
            case let .emailLogin(store):
                EmailLoginView(store: store)
                
            case let .forgotPassword(store):
                ForgotPasswordView(store: store)
                
            case let .phoneLogin(store):
                PhoneLoginView(store: store)
                
            case let .phoneOTP(store):
                PhoneOTPView(store: store)
            }
        }
        .sheet(
            item: $store.scope(state: \.developedBy, action: \.developedBy)
        ) { developedByStore in
            DevelopedByView(store: developedByStore)
        }
        .sheet(
            item: $store.scope(state: \.loginOptions, action: \.loginOptions)
        ) { loginOptionsStore in
            LoginOptionsView(store: loginOptionsStore)
        }
    }
}
