//
//  PhoneLoginView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.08.23.
//

import SwiftUI
import ComposableArchitecture
import iPhoneNumberField

// MARK: - PhoneLoginView

struct PhoneLoginView {
    @Bindable var store: StoreOf<PhoneLoginFeature>
    @FocusState private var focused: Bool
}

// MARK: - Views

extension PhoneLoginView: View {
    
    var body: some View {
        content.onAppear {
            self.focused = true
        }
    }
    
    @ViewBuilder private var content: some View {
        VStack(spacing: 24) {
            Text("Please note that you need to type at least one number for it to pass validation.")
                .multilineTextAlignment(.center)
                .font(.headline)
            
            iPhoneNumberField(text: $store.number)
                .flagHidden(false)
                .flagSelectable(true)
                .maximumDigits(10)
                .foregroundColor(Color.black)
                .clearButtonMode(.whileEditing)
                .accentColor(Color.black)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black03, lineWidth: 0.5)
                )
                .focused($focused)
            
            Button(Localization.Base.continue, action: {
                focused = false
                store.send(.view(.onContinueButtonTap))
            })
            .buttonStyle(.cta)
            .disabled(store.isContinueButtonDisabled)
            
            Spacer()
        }
        .loader(isLoading: store.isActivityIndicatorVisible)
        .padding(24)
        .navigationTitle("Login with phone")
    }
}
