//
//  AccountAddressView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.08.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - AccountAddressView

struct AccountAddressView {
    let store: StoreOf<AccountAddressReducer>
}

// MARK: - Views

extension AccountAddressView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("Add Address")
                    .font(.largeTitle)
                
                SearchInputView(
                    store: self.store.scope(
                        state: \.input,
                        action: AccountAddressReducer.Action.input
                    )
                )
                .padding()
                
                Spacer()
            }
        }
    }
}
