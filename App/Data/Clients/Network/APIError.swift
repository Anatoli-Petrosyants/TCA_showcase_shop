//
//  APIError.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import Foundation
import enum Moya.MoyaError

enum APIError {
    case serverUnavailable
    case unauthorized
    case underlying(Error)
    case moyaError(MoyaError)
}

extension APIError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .serverUnavailable:
            return "An error occurred. Please try again later."
        case .unauthorized:
            return "Unauthorized."
        case .underlying(let error):
            return error.localizedDescription
        case .moyaError(let moyaError):
            switch moyaError {
            case .underlying(let error, _):
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let error):
                        let nsError = error as NSError
                        switch nsError.code {
                        case NSURLErrorNotConnectedToInternet,
                             NSURLErrorNetworkConnectionLost:
                            return error.localizedDescription
                        default:
                            return NSLocalizedString("error.unknown", comment: "")
                        }
                    default:
                        return NSLocalizedString("error.unknown", comment: "")
                    }
                }
                return NSLocalizedString("error.unknown", comment: "")
            default:
                return NSLocalizedString("error.unknown", comment: "")
            }
        }
    }
    
    var failureReason: String? {
        switch self {
        case .serverUnavailable:
            return "Something went wrong when connecting to the server"
        case .unauthorized:
            return "Unauthorized"
        case .underlying(let apiError):
            return apiError.asAFError?.failureReason
        case .moyaError(let moyaError):
            return moyaError.failureReason
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .serverUnavailable:
            return "Retry requests 3 times delayed"
        case .unauthorized:
            return "Refresh token if possible"
        case .underlying(let apiError):
            return apiError.asAFError?.recoverySuggestion
        case .moyaError(let moyaError):
            return moyaError.recoverySuggestion
        }
    }
}

extension APIError: Equatable {

    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        return true
    }
}
