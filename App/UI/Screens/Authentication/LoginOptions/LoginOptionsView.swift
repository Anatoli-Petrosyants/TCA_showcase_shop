//
//  LoginOptionsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 01.09.23.
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
            VStack {
                Button(Localization.LoginOptions.loginEmail, action: {
                    viewStore.send(.view(.onEmailLoginButtonTap))
                })
                .buttonStyle(.cta)
                .padding(.top, 6)
                
                Button(Localization.LoginOptions.loginPhone, action: {
                    viewStore.send(.view(.onPhoneLoginButtonTap))
                })
                .buttonStyle(.cta)
                
                Text(viewStore.agreementsAttributedString)
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding([.top, .bottom], 24)
                
                Spacer()
            }
            .padding(24)
            .presentationDetents([.height(262)])
            .presentationDragIndicator(.visible)
        }
    }
}
