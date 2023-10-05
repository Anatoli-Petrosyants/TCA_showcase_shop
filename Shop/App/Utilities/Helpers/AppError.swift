//
//  AppError.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

public enum AppError: Error {
    case general
    case underlying(Error)
    case databaseFailure(internalCode: Int)
}

extension AppError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .general:
            return "An error occurred. Please try again later."
        case .underlying(let error):
            return error.localizedDescription
        case .databaseFailure:
            return "A serious database failure occurred."
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .general:
            return "Failure reason. Please try again later."
        case .underlying(let error):
            return error.localizedDescription
        case .databaseFailure(let code):
            return "Database failure reason (#\(code))"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .general:
            return "Recovery suggestion. Please try again later."
        case .underlying(let error):
            return error.localizedDescription
        case .databaseFailure(let code):
            return "Please contact support and provide a database failure code (#\(code))"
        }
    }
}

extension AppError: Equatable {

    public static func == (lhs: AppError, rhs: AppError) -> Bool {
        return true
    }
}
