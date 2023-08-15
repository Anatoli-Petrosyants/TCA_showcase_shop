//
//  EditProfilesUseCase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.03.23.
//

import Foundation

protocol TodoUseCaseProtocol {
    var items: [Todo] { get set }
    
    func fetch(completion: ResultBlock<[Todo], Error>?)
    func save(_ item: Todo, completion: ResultBlock<[Todo], Error>?)
    func delete(_ offsets: IndexSet, completion: ResultBlock<[Todo], Error>?)
    func swap(_ offsets: IndexSet, destination: Int, completion: ResultBlock<[Todo], Error>?)
}

class TodoUseCase: TodoUseCaseProtocol {
    
    let repository: TodoRepositoryProtocol
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: TodoUseCaseProtocol
    
    var items: [Todo] = []
    
    func fetch(completion: ResultBlock<[Todo], Error>?) {
        repository.fetch { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.items.removeAll()
                self.items.append(contentsOf: data)
                
            case .failure(_):
                break
            }
        }
    }
    
    func save(_ item: Todo, completion: ResultBlock<[Todo], Error>?) {
        repository.save(item) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(item):
                self.items.append(item)
                completion?(.success(self.items))
                
            case .failure(_):
                break
            }
        }
    }
    
    func delete(_ offsets: IndexSet, completion: ResultBlock<[Todo], Error>?) {
        offsets.sorted(by: > ).forEach { [weak self] index in
            guard let self = self else { return }
            let item = self.items[index]
            self.repository.delete(item, completion: { result in
                switch result {                    
                case .success:
                    self.items.remove(at: index)
                    completion?(.success(self.items))
                    
                case .failure(_):
                    break
                }
            })
        }
    }
    
    func swap(_ offsets: IndexSet, destination: Int, completion: ResultBlock<[Todo], Error>?) {
        Log.debug("Inital: \(self.items)")
        
        var items = self.items
        items.move(fromOffsets: offsets, toOffset: destination)
        self.items = items
        
        Log.debug("Swapped: \(self.items)")
        
        completion?(.success(items))
    }
}


