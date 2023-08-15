//
//  ProfileDTO+MockedData.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.03.23.
//

import Foundation

#if DEBUG

extension TodoDTO {

    static let mockedData = TodoDTO(id: UUID(), title: "sample@mail.com", description: "Jhon")        
}

#endif
