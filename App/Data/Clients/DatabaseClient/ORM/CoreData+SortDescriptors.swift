//
//  CoreData+SortDescriptors.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.07.23.
//

import Foundation

// MARK: - SortDescriptor

struct SortDescriptor: Equatable {
    let keyPathString: String
    var ascending = true
}

extension SortDescriptor {
    var object: NSSortDescriptor {
        .init(
            key: keyPathString,
            ascending: ascending
        )
    }
}

extension SortDescriptor {
    init(
        keyPath: KeyPath<some Any, some Any>,
        ascending: Bool
    ) {
        self.keyPathString = NSExpression(forKeyPath: keyPath).keyPath
        self.ascending = ascending
    }
}
