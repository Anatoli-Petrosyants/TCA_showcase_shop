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
                    Text("Login options view")
                    
                    Button(Localization.Base.continue, action: {
                        viewStore.send(.onEmailLoginButtonTap)
                    })
                    .buttonStyle(.cta)
                    .padding(.top, 24)
                }
                .padding()
                .navigationTitle(Localization.Login.title)
                .modifier(NavigationBarModifier())
            } destination: {
                switch $0 {
                case .emailLogin:
                    CaseLet(/LoginOptionsReducer.Path.State.emailLogin,
                        action: LoginOptionsReducer.Path.Action.emailLogin,
                        then: EmailLoginView.init(store:)
                    )
                }
            }
            
            
        }
    }
}
