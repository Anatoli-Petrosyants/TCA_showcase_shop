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
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("PhoneOTP View")
        }
    }
}
