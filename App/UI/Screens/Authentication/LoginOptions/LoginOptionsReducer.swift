//
//  LoginOptionsReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 01.09.23.
//

import SwiftUI
import ComposableArchitecture

struct LoginOptionsReducer: Reducer {
    
    struct State: Equatable, Hashable {
        var agreementsAttributedString: AttributedString {
            var result = AttributedString("By authorizing you agree our Terms and Conditions and Privacy Policy.")
            
            // We can force unwrap the link range,
            // because we are sure in this case,
            // that `website` string is present.
            let termsRange = result.range(of: "Terms and Conditions")!
            result[termsRange].link = Constant.termsURL
            result[termsRange].underlineStyle = Text.LineStyle(pattern: .solid)
            result[termsRange].foregroundColor = Color.blue
            
            let privacyRange = result.range(of: "Privacy Policy")!
            result[privacyRange].link = Constant.privacyURL
            result[privacyRange].underlineStyle = Text.LineStyle(pattern: .solid)
            result[privacyRange].foregroundColor = Color.blue
            
            return result
        }
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onEmailLoginButtonTap
            case onPhoneLoginButtonTap
        }
        
        enum Delegate {
            case didEmailLoginButtonSelected
            case didPhoneLoginButtonSelected
        }

        case view(ViewAction)
        case delegate(Delegate)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {            
            case let .view(viewAction):
                switch viewAction {
                case .onEmailLoginButtonTap:
                    return .concatenate(
                        .send(.delegate(.didEmailLoginButtonSelected)),
                        .run { _ in await self.dismiss() }
                    )
                    
                case .onPhoneLoginButtonTap:
                    return .concatenate(
                        .send(.delegate(.didPhoneLoginButtonSelected)),
                        .run { _ in await self.dismiss() }
                    )
                }
                
            case .delegate:
                return .none
                
                
            }
        }
    }
}
