//
//  AgreementsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - AgreementsView

struct AgreementsView {
    let store: StoreOf<Agreements>
}

// MARK: - Views

extension AgreementsView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
            
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                Text(Localization.Agreements.title)
                    .font(.largeTitleBold)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 24)
                
                ScrollView {
                    Text(viewStore.text)
                        .font(.body)
                }
            }
            .padding(24)
            
            Button(Localization.Agreements.accept, action: {
                viewStore.send(.view(.onAcceptTap))
            })
            .buttonStyle(.cta)
            .padding([.leading, .trailing], 48.0.scaled())
        }
    }
}
