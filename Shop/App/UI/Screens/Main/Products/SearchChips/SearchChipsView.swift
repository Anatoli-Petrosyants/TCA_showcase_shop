//
//  SearchChipsView.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 24.05.24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SearchChipsView

struct SearchChipsView {
    @Bindable var store: StoreOf<SearchChipsFeature>
}

// MARK: - Views

extension SearchChipsView: View {
    
    var body: some View {
        content
    }

    @ViewBuilder private var content: some View {
        SearchChipsControl(chips: store.chips, selectedChip: $store.selectedChip)
    }
}

// MARK: SearchChipsControl

struct SearchChipsControl: View {
    var chips: [Chip]
    @Binding var selectedChip: Chip

    var body: some View {        
        WrappingHStack(models: chips) { chip in
            Text(chip.description)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(22)
                .shadow(color: .black01, radius: 10.0)
                .padding(.vertical, 3)
                .padding(.horizontal, 2)
                .onTapGesture {
                    selectedChip = chip
                }
        }
    }
}

struct SearchChipsItemView: View {
    let chip: Chip
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            Text(chip.description)
                .font(.body)
                .padding(.vertical, 8)

            if isSelected {
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.black)
            } else {
                Color.clear
                    .frame(height: 2)
            }
        }
    }
}

