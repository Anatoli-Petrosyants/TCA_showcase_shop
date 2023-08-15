//
//  TodoLocalRepository.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.03.23.
//

import Foundation

class TodoLocalRepository: TodoRepositoryProtocol {
    
    var items: [TodoDTO]
    
    init() {
        self.items = []
    }
    
    func fetch(completion: ResultBlock<[Todo], Error>?) {
        Log.debug("Fetch \(items)")
        
        let entities = items.map { $0.toEntity() }
        completion?(.success(entities))
    }

    func save(_ item: Todo, completion: ResultBlock<Todo, Error>?) {
        Log.debug("Save \(item)")
        
        items.append(item.toDTO())
        completion?(.success(item))
    }
    
    func delete(_ item: Todo, completion: ResultBlock<Todo, Error>?) {
        Log.debug("Delete \(item)")
        
        guard let index = items.firstIndex(where: {$0.id == item.id}) else { return }
        items.remove(at: index)
        completion?(.success(item))
    }
}

extension Array where Element: AnyObject {
    mutating func removeFirst(object: AnyObject) {
        guard let index = firstIndex(where: {$0 === object}) else { return }
        remove(at: index)
    }
}
