//
//  UserDefaultsModel.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.03.23.
//

import SwiftUI

// MARK: - Intent Actions

protocol UserDefaultsModelActionsProtocol: AnyObject {
    typealias Action = UserDefaultsModel.Action
    func mutate(action: Action)
}

// MARK: - View State

protocol UserDefaultsModelStatePotocol {
    var navigationTitle: String { get }
    var showButtonTitle: String { get }
    var resetButtonTitle: String { get }
    var showOnboardingAlert: Bool { get }
}

final class UserDefaultsModel: ObservableObject, UserDefaultsModelStatePotocol {
    
    @Published var navigationTitle = "UserDefaults"
    @Published var showButtonTitle = "Show Onboarding Alert"
    @Published var resetButtonTitle = "Reset"
    @Published var showOnboardingAlert = false
}

// MARK: - Actions

extension UserDefaultsModel {
    enum Action {
        case showOnboardingAlert(Bool)
    }
}

extension UserDefaultsModel: UserDefaultsModelActionsProtocol {
    
    func mutate(action: Action) {
        switch action {
        case let .showOnboardingAlert(value):
            showOnboardingAlert = value
        }
    }
}
