//
//  LoginView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - LoginView

struct LoginView {
    let store: StoreOf<LoginReducer>
}

// MARK: - Views

extension LoginView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStackStore(
                self.store.scope(state: \.path, action: LoginReducer.Action.path)
            ) {
//                BlurredActivityIndicatorView(
//                    isShowing: viewStore.binding(\.$isActivityIndicatorVisible))
//                {
//                    VStack {
//                        VStack {
//                            TextField(
//                                Localization.Base.emailPlacholder,
//                                text: viewStore.binding(\.$email)
//                            )
//                            .autocapitalization(.none)
//                            .keyboardType(.emailAddress)
//                            .textContentType(.emailAddress)
//                            .textFieldStyle(.main)
//
//                            SecureField(
//                                "••••••••",
//                                text: viewStore.binding(\.$password)
//                            )
//                            .textFieldStyle(.main)
//                            
//                            HStack {
//                                Spacer()
//                                Button(Localization.Login.forgotPassword, action: {
//                                    viewStore.send(.view(.onForgotPasswordButtonTap))
//                                })
//                                .buttonStyle(.linkButton)
//                            }
//                            .padding(.top, 16)
//                            
//                            Button(Localization.Base.continue, action: {
//                                viewStore.send(.view(.onSignInButtonTap))
//                            })
//                            .buttonStyle(.cta)
//                            .padding(.top, 24)
//                        }
//                        .padding(24)
//                        
//                        Spacer()
//
//                        Button(Localization.Login.agreements, action: {
//                            viewStore.send(.view(.onAgreementsTap))
//                        })
//                        .buttonStyle(.linkButton)
//                        .padding(.bottom, 24)
//                    }
//                    .navigationTitle(Localization.Login.title)
//                    .modifier(NavigationBarModifier())
//                }
            } destination: {
                switch $0 {
                case .forgotPassword:
                    CaseLet(/LoginReducer.Path.State.forgotPassword,
                        action: LoginReducer.Path.Action.forgotPassword,
                        then: ForgotPasswordView.init(store:)
                    )
                }
            }
            .sheet(
                store: store.scope(state: \.$agreements, action: LoginReducer.Action.agreements),
                content: AgreementsView.init(store:)
            )
            .alert(store: self.store.scope(state: \.$alert, action: LoginReducer.Action.alert))
        }
    }
}
