//
//  IntentBindingType.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 17.03.23.
//

import Foundation

protocol IntentBindingType {
    associatedtype IntentType
    associatedtype ViewState

    var container: MVIContainer<IntentType, ViewState> { get }
    var intent: IntentType { get }
    var state: ViewState { get }
}
