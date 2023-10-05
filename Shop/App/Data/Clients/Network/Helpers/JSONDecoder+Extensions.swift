//
//  JSONDecoder+Extensions.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import Foundation

extension JSONDecoder {
    
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
