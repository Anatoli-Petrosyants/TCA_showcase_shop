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
    let store: StoreOf<PhoneLoginReducer>
    
    @FocusState private var focused: Bool
    @State private var text = ""
}

// MARK: - Views

extension PhoneLoginView: View {
    
    var body: some View {
        content.onAppear {
            self.focused = true
        }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 24) {
                Text("Type '6' for all numbers to pass validation.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                
                iPhoneNumberField(text: $text)
                    .flagHidden(false)
                    .flagSelectable(true)
                    .maximumDigits(10)
                    .foregroundColor(Color.black)
                    .clearButtonMode(.whileEditing)
                    // .onClear { _ in self.focused = false }
                    .accentColor(Color.black)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black03, lineWidth: 0.5)
                    )
                    .focused(self.$focused)
                
                Button(Localization.Base.continue, action: {
                    
                })
                .buttonStyle(.cta)
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Login with phone")
        }
    }
}
