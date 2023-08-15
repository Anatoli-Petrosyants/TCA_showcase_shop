//
//  HomeModel.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.03.23.
//

import SwiftUI

// MARK: - Intent Actions

protocol HomeModelActionsProtocol: AnyObject {
    typealias Action = HomeModel.Action
    func mutate(action: Action)
}

// MARK: - View State

protocol HomeModelStatePotocol {
    typealias ContentState = HomeModel.ContentState
    var navigationTitle: LocalizedStringKey { get }
    var contentState: ContentState { get }
}

final class HomeModel: ObservableObject, HomeModelStatePotocol {

    @Published
    var navigationTitle: LocalizedStringKey = "showcase.title"
    
    @Published
    var contentState: ContentState = .loading
}

// MARK: - Actions

extension HomeModel {
    enum Action {
        case success(data: [Component])
        case failed(error: Error)
    }
    
    enum ContentState {
        case loading
        case success(data: [Component])
        case failed(error: Error)
    }
}

extension HomeModel: HomeModelActionsProtocol {
    
    func mutate(action: Action) {
        switch action {
        case .success(data: let data):
            contentState = .success(data: data)
        case .failed(error: let error):
            contentState = .failed(error: error)
        }
    }
}
