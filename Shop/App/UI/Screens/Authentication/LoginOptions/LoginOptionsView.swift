//
//  LoginOptionsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 01.09.23.
//

import SwiftUI
import ComposableArchitecture
import AuthenticationServices

// MARK: - LoginOptionsView

struct LoginOptionsView {
    let store: StoreOf<LoginOptionsFeature>
}

// MARK: - Views

extension LoginOptionsView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        VStack(spacing: 12) {
            Button("Continue with Email", action: {
                store.send(.view(.onEmailLoginButtonTap))
            })
            .buttonStyle(.cta)
            
            // #dev please note that this will be declined by apple review. A.P.
            Button("Continue with Apple", action: {
                store.send(.view(.onAppleLoginButtonTap))
            })
            .buttonStyle(.cta)
            .opacity(0.4)
            //.disabled(true)
            
            /*
            SignInWithAppleButton(.signIn,
                         onRequest: { request in
                             request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                   case .success(let authResults):
                      print("Authorization successful authResults \(authResults)")
                   case .failure(let error):
                      print("Authorization failed: " + error.localizedDescription)
                }
            })
            .signInWithAppleButtonStyle(.black)
            */
            
            Button("Continue with Phone", action: {
                store.send(.view(.onPhoneLoginButtonTap))
            })
            .buttonStyle(.cta)
            
            Text(store.agreementsAttributedString)
                .multilineTextAlignment(.center)
                .font(.footnote)
                .padding(.top, 16)
            
            Spacer()
        }
        .padding(.top, 32)
        .padding([.leading, .trailing, .bottom], 24)
        .presentationDetents([.height(320)])
        .presentationDragIndicator(.visible)
    }
}
