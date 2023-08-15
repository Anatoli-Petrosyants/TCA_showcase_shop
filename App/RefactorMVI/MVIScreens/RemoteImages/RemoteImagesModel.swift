//
//  RemoteImagesModel.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import SwiftUI

// MARK: - Intent Actions

protocol RemoteImagesModelActionsProtocol: AnyObject {
    typealias Action = RemoteImagesModel.Action
    func mutate(action: Action)
}

// MARK: - View State

protocol RemoteImagesModelStatePotocol {
    typealias ContentState = RemoteImagesModel.ContentState
    var navigationTitle: String { get }
    var contentState: ContentState { get }
}

final class RemoteImagesModel: ObservableObject, RemoteImagesModelStatePotocol {

    @Published
    var navigationTitle = "Remote Images"
    
    @Published
    var contentState: ContentState = .loading
}

// MARK: - Actions

extension RemoteImagesModel {
    enum Action {        
        case success(data: [RemoteImagesCardViewModel])
        case failed(error: Error)
    }
    
    enum ContentState {
        case loading
        case success(data: [RemoteImagesCardViewModel])
        case failed(error: Error)
    }
}

extension RemoteImagesModel: RemoteImagesModelActionsProtocol {
    
    func mutate(action: Action) {
        switch action {
        case .success(data: let data):
            contentState = .success(data: data)
        case .failed(error: let error):
            contentState = .failed(error: error)
        }
    }
}
