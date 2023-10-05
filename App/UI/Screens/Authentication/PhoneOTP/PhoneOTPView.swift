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
    let store: StoreOf<PhoneOTPFeature>
    
    struct ViewState: Equatable {
        @BindingViewState var code: String
        var isActivityIndicatorVisible: Bool
    }
}

// MARK: - Views

extension PhoneOTPView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
            VStack(spacing: 24) {
                Text("We sent you code via SMS. For test proposal please enter 999999.")
                    .multilineTextAlignment(.center)
                    .font(.headline)

                OTPView(code: viewStore.$code)
                    .padding([.leading, .trailing, .top], 40)
                
//                Button("Resend", action: {
//                    viewStore.send(.onResendButtonTap)
//                })
//                .buttonStyle(.linkButton)

                Spacer()
            }
            .loader(isLoading: viewStore.isActivityIndicatorVisible)
            .padding(24)
            .navigationTitle("Enter Code")
        }
    }
}

// MARK: BindingViewStore

extension BindingViewStore<PhoneOTPFeature.State> {
    var view: PhoneOTPView.ViewState {
        PhoneOTPView.ViewState(code: self.$code,
                               isActivityIndicatorVisible: self.isActivityIndicatorVisible)
    }
}
