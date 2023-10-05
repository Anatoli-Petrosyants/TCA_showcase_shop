//
//  NoNetworkView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - NoNetworkView

struct NoNetworkView {
    let store: StoreOf<NoNetwork>
}

// MARK: - Body

extension NoNetworkView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 30) {
                Spacer()
                
                Text(Localization.Base.oops)
                    .font(Font.title)
                    .multilineTextAlignment(.center)
                
                Image("wifi.exclamationmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128, alignment: .center)

                Text(Localization.Base.noNetworkConnection)
                    .font(Font.title3)
                    .multilineTextAlignment(.center)

                Button(Localization.Base.ok) {
                    viewStore.send(.onOkTapped)
                }
                .buttonStyle(.cta)
                
                Spacer()
            }
            .padding([.leading, .trailing], 48)
            .padding(.top, 64)
        }
    }
}
