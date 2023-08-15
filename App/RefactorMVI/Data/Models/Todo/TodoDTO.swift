//
//  ProfileDTO.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.03.23.
//

import Foundation

struct TodoDTO {
    let id: UUID
    let title: String
    let description: String?
}

extension TodoDTO {
    
    func toEntity() -> Todo {
        return .init(id: id, title: title, description: description)
    }
}
