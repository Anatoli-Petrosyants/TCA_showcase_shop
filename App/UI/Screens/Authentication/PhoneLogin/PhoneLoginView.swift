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
    
    struct ViewState: Equatable {
        @BindingViewState var number: String
        var isContinueButtonDisabled: Bool
    }
}

// MARK: - Views

extension PhoneLoginView: View {
    
    var body: some View {
        content.onAppear {
            self.focused = true
        }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
            VStack(spacing: 24) {
                Text("Chosse USA '(302) 666-6666' number to pass validation.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                
                iPhoneNumberField(text: viewStore.$number)
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
                    .focused(self.$focused)
                
                Button(Localization.Base.continue, action: {
                    viewStore.send(.onContinueButtonTap)
                })
                .buttonStyle(.cta)
                .disabled(viewStore.isContinueButtonDisabled)
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Login with phone")
        }
    }
}

// MARK: BindingViewStore

extension BindingViewStore<PhoneLoginReducer.State> {
    var view: PhoneLoginView.ViewState {
        PhoneLoginView.ViewState(number: self.$number,
                                 isContinueButtonDisabled: self.isContinueButtonDisabled)
    }
}
