//
//  PhoneOTPView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.08.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - PhoneOTPView

struct PhoneOTPView {
    @Bindable var store: StoreOf<PhoneOTPFeature>
}

// MARK: - Views

extension PhoneOTPView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        VStack(spacing: 24) {
            Text("We sent you code via SMS. For test proposal please enter 999999.")
                .multilineTextAlignment(.center)
                .font(.headline)

            OTPView(code: $store.code)
                .padding([.leading, .trailing, .top], 40)
            
//                Button("Resend", action: {
//                    viewStore.send(.onResendButtonTap)
//                })
//                .buttonStyle(.linkButton)

            Spacer()
        }
        .loader(isLoading: store.isActivityIndicatorVisible)
        .padding(24)
        .navigationTitle("Enter Code")
    }
}
