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
            NavigationStack {
                VStack {
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        SearchInputView(
                            store: self.store.scope(
                                state: \.input,
                                action: AccountAddressReducer.Action.input
                            )
                        )
                        .padding(.top, 16)
                    }
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}