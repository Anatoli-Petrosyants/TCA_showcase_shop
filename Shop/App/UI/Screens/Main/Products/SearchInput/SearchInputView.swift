//
//  SearchInputView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SearchInputView

struct SearchInputView {
    let store: StoreOf<SearchInputFeature>
}

// MARK: - Views

extension SearchInputView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(spacing: 16) {    
                    TextField(viewStore.placeholder, text: viewStore.binding(
                        get: \.searchQuery,
                        send: SearchInputFeature.Action.onTextChanged)
                    )
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.leading, 8)
                
                if viewStore.isLoading {
                    ProgressView()
                        .tint(.black)
                        .frame(width: 30, height: 30)                        
                } else {
                    if viewStore.isHiddenClearButton {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 30, height: 30)
                    } else {
                        Image(systemName: "xmark")
                            .frame(width: 30, height: 30)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewStore.send(.onClear)
                            }
                    }
                }
            }
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.black, lineWidth: 1)
//            )
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(22)
            .shadow(color: .black01, radius: 10.0)
        }
    }
}
