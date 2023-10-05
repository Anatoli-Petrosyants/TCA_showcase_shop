//
//  ProductRequest.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

struct ProductRequest: Encodable {    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}
