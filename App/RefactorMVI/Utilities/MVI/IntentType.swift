//
//  IntentType.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 17.03.23.
//

import Foundation
import Combine

protocol IntentType: AnyObject {
    associatedtype ViewAction
    associatedtype ViewState

    var state: ViewState { get set }

    func execute(action: ViewAction)
    func mutate(action: ViewAction)
}

extension IntentType {
    
    func execute(action: ViewAction) {
        mutate(action: action)
    }
}
