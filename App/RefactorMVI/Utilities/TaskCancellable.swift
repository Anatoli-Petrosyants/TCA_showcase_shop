//
//  TaskCancellable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 01.03.23.
//

import Foundation

@resultBuilder
struct TaskBuilder {
    static func buildBlock(_ components:  Task<(), Never>...) -> [ Task<(), Never>] {
        return components
    }
}

class TaskCancellable {
    var tasks: [Task<(), Never>] = []
    
    func addTask(@TaskBuilder _ tasks: () -> [Task<(), Never>]) {
        let builtTasks = tasks()
        
        self.tasks.append(contentsOf: builtTasks)
    }
    
    deinit {
        self.tasks.forEach { task in
            task.cancel()
        }
    }
}
