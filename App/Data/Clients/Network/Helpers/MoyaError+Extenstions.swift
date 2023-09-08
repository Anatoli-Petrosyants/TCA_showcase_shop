//
//  MoyaError+Extenstions.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import enum Moya.MoyaError
import Foundation

extension MoyaError {
    
    var asAPIError: APIError {
        switch self {
        case .underlying(let error, let response):
            guard response != nil else {
                return .underlying(
                    NSError(domain: "", code: 666, userInfo: [NSLocalizedDescriptionKey: "Can't parse error"])
                )
            }

            // Handle server error
            if let responseCode = error.asAFError?.responseCode {
                if (500...510).contains(responseCode) {
                    return .serverUnavailable
                }
            }

            // Handle authentication error
            if error.asAFError?.responseCode == 401 {
                return .unauthorized
            }
            
            return .moyaError(self)
            
        default:
            return .moyaError(self)
        }
    }
}
