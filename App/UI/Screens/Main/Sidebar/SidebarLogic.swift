//
//  ContactUsReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 21.07.23.
//

import UIKit
import ComposableArchitecture

struct SidebarLogic<State>: ReducerProtocol {
    
    @Dependency(\.applicationClient.open) var openURL
    @Dependency(\.applicationClient.setUserInterfaceStyle) var setUserInterfaceStyle

    func reduce(into _: inout State, action: SidebarReducer.Action) -> EffectTask<SidebarReducer.Action> {
        switch action {
        case let .view(viewAction):
            switch viewAction {
            case .onContactTap:                
                guard let url = URL(string: "mailto:\(Constant.email)") else { return .none }
                guard UIApplication.shared.canOpenURL(url) else { return .none }
                UIApplication.shared.open(url)                
                return .none
            
            case .onRateTap:
                let appId = "1590123645"
                let urlPath = "https://itunes.apple.com/app/id\(appId)?action=write-review"
                guard let url = URL(string: urlPath) else { return .none }
                guard UIApplication.shared.canOpenURL(url) else { return .none }
                UIApplication.shared.open(url)
                return .none
                
            case .onDarkModeTap:
                let style = UIApplication.shared.firstKeyWindow?.overrideUserInterfaceStyle
                return .fireAndForget {
                    await self.setUserInterfaceStyle((style == .dark) ? .light : .dark)
                }
                
            case .onAppSettings:
                return .fireAndForget {
                    _ = await self.openURL(URL(string: UIApplication.openSettingsURLString)!, [:])
                }
                
            default:
                return .none
            }
            
        default:
            return .none
        }
    }
}
