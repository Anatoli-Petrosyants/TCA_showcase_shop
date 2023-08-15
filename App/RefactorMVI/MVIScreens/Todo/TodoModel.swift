//
//  TodoModel.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.03.23.
//

import SwiftUI

// MARK: - Intent Actions

protocol TodoModelActionsProtocol: AnyObject {
    typealias Action = TodoModel.Action
    func mutate(action: Action)
}

// MARK: - View State

protocol TodoModelStatePotocol {
    typealias ContentState = TodoModel.ContentState
    var navigationTitle: LocalizedStringKey { get }
    var headerTitle: LocalizedStringKey { get }
    var footerTitle: LocalizedStringKey { get }
    var contentState: ContentState { get }    
}

final class TodoModel: ObservableObject, TodoModelStatePotocol {
    
    @Published
    var navigationTitle: LocalizedStringKey = "todo.title"
    
    @Published
    var headerTitle: LocalizedStringKey = "todo.section.header"
    
    @Published
    var footerTitle: LocalizedStringKey = "todo.section.footer"
    
    @Published
    var contentState: ContentState = .loading
}

// MARK: - Actions

extension TodoModel {
    enum Action {
        case success(data: [Todo])
    }
    
    enum ContentState {
        case loading
        case success(data: [Todo])
    }
}

extension TodoModel: TodoModelActionsProtocol {
    
    func mutate(action: Action) {
        switch action {
        case .success(data: let data):
            contentState = .success(data: data)
        }
    }
}
