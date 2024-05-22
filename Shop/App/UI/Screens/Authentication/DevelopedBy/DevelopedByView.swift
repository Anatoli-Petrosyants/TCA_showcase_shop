//
//  DevelopedByView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - DevelopedByView

struct DevelopedByView {
    let store: StoreOf<DevelopedByFeature>
}

// MARK: - Views

extension DevelopedByView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
            
    }
    
    @ViewBuilder private var content: some View {
        VStack(alignment: .leading) {
            Text("Developed By")
                .font(.largeTitleBold)
                .multilineTextAlignment(.leading)
                .padding(.top, 24)
            
            ScrollView {
                Text(store.text)
                    .font(.body)
            }
        }
        .padding(24)
        
        Button(Localization.Base.continue, action: {
            store.send(.view(.onAcceptTap))
        })
        .buttonStyle(.cta)
        .padding(24)
    }
}
