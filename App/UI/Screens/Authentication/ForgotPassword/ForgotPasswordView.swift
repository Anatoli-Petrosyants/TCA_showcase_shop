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
    let store: StoreOf<ForgotPassword>
}

// MARK: - Views

extension ForgotPasswordView: View {
    
    var body: some View {
        content
            .navigationTitle(Localization.ForgotPassword.title)
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                VStack {
                    
                }
                .padding(24)
                
                Spacer()

                Button(Localization.ForgotPassword.changePassword, action: {
                    viewStore.send(.view(.onChangePasswordButtonTap))
                })
                .buttonStyle(.cta)
                .padding([.leading, .trailing], 48.0.scaled())
            }
        }
        .alert(store: self.store.scope(state: \.$alert, action: ForgotPassword.Action.alert))
    }
}
