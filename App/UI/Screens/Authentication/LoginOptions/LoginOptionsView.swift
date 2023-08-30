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
                    Image(systemName: "pencil.slash")
                        .font(.system(size: 100))
                        .padding(.top, 64)
                    
                    Text("Please select the login option to explore the showcase project developed by Anatoli Petrosyants.")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(.top, 24)
                    
                    Spacer()
                    
                    Button("Login with email", action: {
                        viewStore.send(.onEmailLoginButtonTap)
                    })
                    .buttonStyle(.cta)
                                        
                    Text("or")
                        .font(.headline)
                        .foregroundColor(Color.black05)
                    
                    Button("Login with phone", action: {
                        viewStore.send(.onEmailLoginButtonTap)
                    })
                    .buttonStyle(.cta)
                }
                .padding()
                .navigationTitle("Welcome")
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
