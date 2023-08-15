//
//  RemoteImageWeb.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import Foundation

struct RemoteImageDTO {
    let path: String?
}

extension RemoteImageDTO {
    
    func toEntity() -> RemoteImage {
        return .init(path: self.path.valueOr(""))
    }
}
