//
//  OnboardingModel.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

// MARK: - Intent Actions

protocol OnboardingModelActionsProtocol: AnyObject {
    typealias Action = OnboardingModel.Action
    func mutate(action: Action)
}

// MARK: - View State

protocol OnboardingModelStatePotocol {
    var navigationTitle: String { get }
}

final class OnboardingModel: ObservableObject, OnboardingModelStatePotocol {
    
    @Published
    var navigationTitle = "Onboarding"
}

// MARK: - Actions

extension OnboardingModel {
    enum Action {
        
    }
}

extension OnboardingModel: OnboardingModelActionsProtocol {
    
    func mutate(action: Action) {
        
    }
}
