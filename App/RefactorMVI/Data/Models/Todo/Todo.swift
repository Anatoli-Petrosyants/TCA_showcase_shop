//
//  Profile.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.03.23.
//

import Foundation

struct Todo: Identifiable {
    let id: UUID
    let title: String
    let description: String?
}

extension Todo {
    
    func toDTO() -> TodoDTO {
        return .init(id: id, title: title, description: description)
    }
}
