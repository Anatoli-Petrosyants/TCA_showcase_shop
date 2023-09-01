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
    let store: StoreOf<PhoneOTPReducer>
}

// MARK: - Views

extension PhoneOTPView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 24) {
                Text("We sent you code via SMS")
                    .multilineTextAlignment(.center)
                .font(.headline)
                
                OTPView(activeIndicatorColor: Color.black,
                        inactiveIndicatorColor: Color.black03,
                        length: 4,
                        doSomething: { value in
                    print("OTPView value \(value)")
                })
                
                Button("Resend", action: {
                    // viewStore.send(.onContinueButtonTap)
                })
                .buttonStyle(.linkButton)
                
                Spacer()
            }
            // .loader(isLoading: viewStore.isActivityIndicatorVisible)
            .padding(24)
            .navigationTitle("Enter Code")
        }
    }
}
