//
//  TodoIntent.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.03.23.
//

import SwiftUI

protocol TodoIntentProtocol {
    typealias Action = TodoIntent.Action
    func execute(action: Action)
}

final class TodoIntent {
    
    private weak var model: TodoModelActionsProtocol?
    private var usecase: TodoUseCaseProtocol
    
    init(model: TodoModelActionsProtocol, usecase: TodoUseCaseProtocol) {
        self.model = model
        self.usecase = usecase
    }
}

// MARK: Actions

extension TodoIntent {
    enum Action {
        case onViewApear
        case onAdd(title: String, description: String)
        case onDelete(offsets: IndexSet)
        case onMove(source: IndexSet, destination: Int)
    }
}

extension TodoIntent: TodoIntentProtocol {
    
    func execute(action: Action) {
        switch action {
        case .onViewApear:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.model?.mutate(action: .success(data: []))
            }
            
        case let .onAdd(title: title, description: description):
            let todo = Todo(id: UUID(), title: "\(title)", description: "\(description)")

            usecase.save(todo) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(items):
                    self.model?.mutate(action: .success(data: items))
                case .failure(_):
                    break
                }
            }
            
        case let .onDelete(offsets: offsets):
            usecase.delete(offsets) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(items):
                    self.model?.mutate(action: .success(data: items))
                case .failure(_):
                    break
                }
            }
            
        case let .onMove(source: source, destination: destination):
            usecase.swap(source, destination: destination) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(items):
                    self.model?.mutate(action: .success(data: items))
                case .failure(_):
                    break
                }
            }
        }
    }
}

// MARK: Helpers

private extension TodoIntent {

}
