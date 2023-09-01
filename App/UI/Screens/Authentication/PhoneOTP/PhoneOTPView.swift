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
    
    @State private var code: String = ""
}

// MARK: - Views

extension PhoneOTPView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 24) {
                Text("We sent you code via SMS. For test proposal please enter 6666.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                
//                OTPView(activeIndicatorColor: Color.black,
//                        inactiveIndicatorColor: Color.black03,
//                        length: 4,
//                        doSomething: { value in
//                    viewStore.send(.view(.onCodeChanged(value)))
//                })
                
                OTPView(code: $code)
                    .padding(40)
                
                Button("Resend", action: {
                    viewStore.send(.view(.onResendButtonTap))
                })
                .buttonStyle(.linkButton)

                Spacer()
            }
            .padding(24)
            .navigationTitle("Enter Code")
        }
    }
}

//import SwiftUI
//import ComposableArchitecture
//
//// MARK: - PhoneOTPView
//
//struct PhoneOTPView {
//    let store: StoreOf<PhoneOTPReducer>
//}
//
//// MARK: - Views
//
//extension PhoneOTPView: View {
//
//    var body: some View {
//        content
//    }
//
//    @ViewBuilder private var content: some View {
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
//            VStack(spacing: 24) {
//                Text("We sent you code via SMS")
//                    .multilineTextAlignment(.center)
//                .font(.headline)
//
//                OTPView(activeIndicatorColor: Color.black,
//                        inactiveIndicatorColor: Color.black03,
//                        length: 4,
//                        doSomething: { value in
//                    print("onCodeChanged value \(value)")
////                    viewStore.send(.view(.onCodeChanged(value)))
//                })
//
//                Button("Resend", action: {
//                    viewStore.send(.view(.onResendButtonTap))
//                })
//                .buttonStyle(.linkButton)
//
//                Spacer()
//            }
//            // .loader(isLoading: viewStore.isActivityIndicatorVisible)
//            .padding(24)
//            .navigationTitle("Enter Code")
//        }
//    }
//}
