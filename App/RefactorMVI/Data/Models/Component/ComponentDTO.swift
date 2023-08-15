//
//  ComponentDTO.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

struct ComponentDTO {
    let name: String?
    let type: String?
}

extension ComponentDTO {
    
    func toEntity() -> Component {
        return .init(name: self.name.valueOr("unknown"),
                     type: ComponentType(rawValue: self.type.valueOr("")).valueOr(.unknown))
    }
}
