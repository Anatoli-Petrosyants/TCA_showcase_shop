//
//  OpenSafariModel.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

// MARK: - Intent Actions

protocol OpenSafariModelActionsProtocol: AnyObject {
    typealias Action = OpenSafariModel.Action
    func mutate(action: Action)
}

// MARK: - View State

protocol OpenSafariModelStatePotocol {
    var navigationTitle: String { get }
    var outAppPath: URL { get }
    var inAppPath: URL { get }
}

final class OpenSafariModel: ObservableObject, OpenSafariModelStatePotocol {
    
    @Published
    var navigationTitle = "Open Safari"
    
    @Published
    var outAppPath = URL(string: "https://www.apple.com")!
    
    @Published
    var inAppPath = URL(string: "https://www.apple.com")!
}

// MARK: - Actions

extension OpenSafariModel {
    enum Action {
        
    }
}

extension OpenSafariModel: OpenSafariModelActionsProtocol {
    
    func mutate(action: Action) {
        
    }
}
