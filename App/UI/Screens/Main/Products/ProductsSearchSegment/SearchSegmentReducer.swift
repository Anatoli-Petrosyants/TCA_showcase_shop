//
//  ProductsSearchSegmentReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.07.23.
//

import SwiftUI
import ComposableArchitecture

struct ProductsSearchSegmentReducer: Reducer {
    
    struct State: Equatable, Hashable {
        var segments = Segment.allCases
        @BindingState var selectedSegment = Segment.all
    }
    
    enum Action: BindableAction, Equatable {
        enum Delegate: Equatable {
            case didSegmentedChanged(String)
        }
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.$selectedSegment):
                return .send(.delegate(.didSegmentedChanged(state.selectedSegment.query)))
                
            case .binding, .delegate:
                return .none
            }
        }
    }
}

enum Segment: String, CaseIterable {
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
