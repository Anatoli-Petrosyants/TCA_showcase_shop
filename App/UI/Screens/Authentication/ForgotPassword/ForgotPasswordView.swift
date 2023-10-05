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
    let store: StoreOf<ForgotPasswordFeature>
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
                Spacer()

                Button(Localization.ForgotPassword.changePassword, action: {
                    viewStore.send(.view(.onChangePasswordButtonTap))
                })
                .buttonStyle(.cta)
            }
            .padding(24)
        }
        .alert(store: self.store.scope(state: \.$alert, action: ForgotPasswordFeature.Action.alert))
    }
}
