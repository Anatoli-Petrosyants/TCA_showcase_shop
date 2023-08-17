//
//  CountriesReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct CountriesReducer: Reducer {
    
    struct State: Equatable {
        var countryCodes = NSLocale.isoCountryCodes
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onCloseTap
            case onItemTap(code: String)
        }
        
        enum InternalAction: Equatable {
            
        }

        enum Delegate: Equatable {
            case didCountryCodeSelected(String)
        }

        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                // view actions
                case let .view(viewAction):
                    switch viewAction {
                    case .onCloseTap:
                        return .run { _ in await self.dismiss() }
                        
                    case let .onItemTap(code):
                        return .concatenate(
                            .send(.delegate(.didCountryCodeSelected(code))),
                            .run { _ in await self.dismiss() }
                        )
                    }
                    
                // internal actions
                case .internal, .delegate:
                    return .none

            }
        }
    }
}
