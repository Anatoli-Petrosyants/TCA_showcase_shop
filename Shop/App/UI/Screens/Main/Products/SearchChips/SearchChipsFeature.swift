//
//  SearchChipsFeature.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 24.05.24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SearchChipsFeature {
    
    @ObservableState
    struct State: Hashable {
        var chips = Chip.allCases
        var selectedChip = Chip.all
    }
    
    enum Action: BindableAction {
        enum Delegate: Equatable {
            case didChipSelected(String)
        }
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.selectedChip):
                return .send(.delegate(.didChipSelected(state.selectedChip.query)))
                
            case .binding, .delegate:
                return .none
            }
        }
    }
}

enum Chip: String, CaseIterable {
    case all
    case mClothing
    case wClothing
    case jewelery
    case electronics
    
    var query: String {
        switch self {
        case .all:
            return ""
        case .mClothing:
            return "men's clothing"
        case .wClothing:
            return "women's clothing"
        case .jewelery:
            return "jewelery"
        case .electronics:
            return "electronics"
        }
    }
    
    var description: String {
        switch self {
        case .all:
            return "all"
        case .mClothing:
            return "men's clothing"
        case .wClothing:
            return "women's clothing"
        case .jewelery:
            return "jewelery"
        case .electronics:
            return "electronics"
        }
    }
}
