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
    let store: StoreOf<EmailLoginReducer>
    
    struct ViewState: Equatable {
        @BindingViewState var isActivityIndicatorVisible: Bool
        @BindingViewState var email: String
        @BindingViewState var password: String
    }
}

// MARK: - Views

extension EmailLoginView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
//            NavigationStackStore(
//                self.store.scope(state: \.path, action: EmailLoginReducer.Action.path)
//            ) {
                BlurredActivityIndicatorView(
                    isShowing: viewStore.$isActivityIndicatorVisible)
                {
                    VStack {
                        VStack {
                            TextField(
                                Localization.Base.emailPlacholder,
                                text: viewStore.$email
                            )
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .textFieldStyle(.main)

                            SecureField(
                                "••••••••",
                                text: viewStore.$password
                            )
                            .textFieldStyle(.main)

                            HStack {
                                Spacer()
                                Button(Localization.Login.forgotPassword, action: {
                                    viewStore.send(.onForgotPasswordButtonTap)
                                })
                                .buttonStyle(.linkButton)
                            }
                            .padding(.top, 16)

                            Button(Localization.Base.continue, action: {
                                viewStore.send(.onSignInButtonTap)
                            })
                            .buttonStyle(.cta)
                            .padding(.top, 24)
                        }
                        .padding(24)
                        
                        Spacer()

                        Button(Localization.Login.agreements, action: {
                            viewStore.send(.onAgreementsTap)
                        })
                        .buttonStyle(.linkButton)
                        .padding(.bottom, 24)
                    }
                    .navigationTitle(Localization.Login.title)
                    .modifier(NavigationBarModifier())
                }
//            } destination: {
//                switch $0 {
//                case .forgotPassword:
//                    CaseLet(/EmailLoginReducer.Path.State.forgotPassword,
//                        action: EmailLoginReducer.Path.Action.forgotPassword,
//                        then: ForgotPasswordView.init(store:)
//                    )
//                }
//            }
            .sheet(
                store: self.store.scope(state: \.$agreements, action: EmailLoginReducer.Action.agreements),
                content: AgreementsView.init(store:)
            )
            .alert(store: self.store.scope(state: \.$alert, action: EmailLoginReducer.Action.alert))
        }
    }
}

// MARK: BindingViewStore

extension BindingViewStore<EmailLoginReducer.State> {
    var view: EmailLoginView.ViewState {
        EmailLoginView.ViewState(isActivityIndicatorVisible: self.$isActivityIndicatorVisible,
                            email: self.$email,
                            password: self.$password)
    }
}
