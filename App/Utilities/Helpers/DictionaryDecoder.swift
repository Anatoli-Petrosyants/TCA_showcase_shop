//
//  DictionaryDecoder.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.09.23.
//

//Source: https://stackoverflow.com/a/52308446

import Foundation

class DictionaryDecoder {

    private let decoder = JSONDecoder()

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        set { decoder.dateDecodingStrategy = newValue }
        get { return decoder.dateDecodingStrategy }
    }

    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        set { decoder.dataDecodingStrategy = newValue }
        get { return decoder.dataDecodingStrategy }
    }

    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        set { decoder.nonConformingFloatDecodingStrategy = newValue }
        get { return decoder.nonConformingFloatDecodingStrategy }
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        set { decoder.keyDecodingStrategy = newValue }
        get { return decoder.keyDecodingStrategy }
    }

    func decode<T>(_ type: T.Type, from jsonObject: Any) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        return try decoder.decode(type, from: data)
    }
}
