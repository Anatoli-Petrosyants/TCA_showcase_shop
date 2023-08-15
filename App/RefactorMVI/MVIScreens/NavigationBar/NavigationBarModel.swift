//
//  NavigationBarModel.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.03.23.
//

import SwiftUI

enum NavigationBarModel {
    
    struct State {
        var navigationTitle: LocalizedStringKey
        var cancelButtonTitle: LocalizedStringKey
        var showInfoAlert: Bool
        var showAddAlert: Bool
        var showActionSheet: Bool
    }

    enum Action {
        case onViewApear
        case onInfoButtonTap
        case onAddButtonTap
        case onTrashButtonTap
    }
}
