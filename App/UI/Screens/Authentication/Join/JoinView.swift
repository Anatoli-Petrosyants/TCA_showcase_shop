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
    let store: StoreOf<JoinFeature>
}

// MARK: - Views

extension JoinView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in            
            NavigationStackStore(
                self.store.scope(state: \.path, action: { .path($0) })
            ) {
                VStack {
                    Spacer()
                    
                    Image(systemName: "pencil.slash")
                        .font(.system(size: 100))

                    VStack(spacing: 6) {
                        Text(Localization.LoginOptions.description)
                            .multilineTextAlignment(.center)
                            .font(.headline)

                        Button {
                            viewStore.send(.view(.onDevelopedByTap))
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
                        viewStore.send(.view(.onJoinButtonTap))
                    })
                    .buttonStyle(.cta)
                }
                .padding(24)
                .navigationTitle(Localization.LoginOptions.title)
                .modifier(NavigationBarModifier())
            } destination: {
                switch $0 {
                case .emailLogin:
                    CaseLet(/JoinFeature.Path.State.emailLogin,
                        action: JoinFeature.Path.Action.emailLogin,
                        then: EmailLoginView.init(store:)
                    )
                    
                case .forgotPassword:
                    CaseLet(/JoinFeature.Path.State.forgotPassword,
                        action: JoinFeature.Path.Action.forgotPassword,
                        then: ForgotPasswordView.init(store:)
                    )
                    
                case .phoneLogin:
                    CaseLet(/JoinFeature.Path.State.phoneLogin,
                        action: JoinFeature.Path.Action.phoneLogin,
                        then: PhoneLoginView.init(store:)
                    )
                    
                case .phoneOTP:
                    CaseLet(/JoinFeature.Path.State.phoneOTP,
                        action: JoinFeature.Path.Action.phoneOTP,
                        then: PhoneOTPView.init(store:)
                    )
                }
            }
            .sheet(
                store: self.store.scope(state: \.$developedBy, action: { .developedBy($0) }),
                content: DevelopedByView.init(store:)
            )
            .sheet(
                store: self.store.scope(state: \.$loginOptions, action: { .loginOptions($0) }),
                content: LoginOptionsView.init(store:)
            )
        }
    }
}
