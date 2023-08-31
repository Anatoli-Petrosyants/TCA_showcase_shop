//
//  LoginOptionsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.08.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - LoginOptionsView

struct LoginOptionsView {
    let store: StoreOf<LoginOptionsReducer>
}

// MARK: - Views

extension LoginOptionsView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in            
            NavigationStackStore(
                self.store.scope(state: \.path, action: LoginOptionsReducer.Action.path)
            ) {
                VStack {
                    Spacer()
                    
                    Image(systemName: "pencil.slash")
                        .font(.system(size: 100))

                    VStack(spacing: 6) {
                        Text(Localization.LoginOptions.description)
                            .multilineTextAlignment(.center)
                            .font(.headline)
                        
                        Button("Anatoli Petrosyants", action: {
                            viewStore.send(.view(.onDevelopedByTap))
                        })
                        .buttonStyle(.linkButton)
                        .font(.headlineBold)
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                    
                    Button(Localization.LoginOptions.loginEmail, action: {
                        viewStore.send(.view(.onEmailLoginButtonTap))
                    })
                    .buttonStyle(.cta)
                    
                    Button(Localization.LoginOptions.loginPhone, action: {
                        viewStore.send(.view(.onPhoneLoginButtonTap))
                    })
                    .buttonStyle(.cta)
                    
                    Text(viewStore.agreementsAttributedString)
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .padding([.top, .bottom], 24)
                }
                .padding(24)
                .navigationTitle(Localization.LoginOptions.title)
                .modifier(NavigationBarModifier())
            } destination: {
                switch $0 {
                case .emailLogin:
                    CaseLet(/LoginOptionsReducer.Path.State.emailLogin,
                        action: LoginOptionsReducer.Path.Action.emailLogin,
                        then: EmailLoginView.init(store:)
                    )
                    
                case .forgotPassword:
                    CaseLet(/LoginOptionsReducer.Path.State.forgotPassword,
                        action: LoginOptionsReducer.Path.Action.forgotPassword,
                        then: ForgotPasswordView.init(store:)
                    )
                    
                case .phoneLogin:
                    CaseLet(/LoginOptionsReducer.Path.State.phoneLogin,
                        action: LoginOptionsReducer.Path.Action.phoneLogin,
                        then: PhoneLoginView.init(store:)
                    )
                }
            }
            .sheet(
                store: self.store.scope(state: \.$developedBy, action: LoginOptionsReducer.Action.developedBy),
                content: DevelopedByView.init(store:)
            )            
        }
    }
}
