//
//  MoyaProvider+Async.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

// https://github.com/Moya/Moya/issues/2265

import Foundation
import Moya

extension MoyaProvider {
    
    class MoyaConcurrency {
        
        private let provider: MoyaProvider
        
        init(provider: MoyaProvider) {
            self.provider = provider
        }
        
        func request(_ endpoint: Target) async throws -> Response {
            return try await withCheckedThrowingContinuation { continuation in
                provider.request(endpoint) { result in
                    switch result {
                    case .success(let response):
                        continuation.resume(returning: response)
                    case .failure(let error):
                        continuation.resume(throwing: error.asAPIError)
                    }
                }
            }
        }
        
        func request<D: Decodable>(_ endpoint: Target) async throws -> D {
            return try await withCheckedThrowingContinuation { continuation in
                provider.request(endpoint) { result in
                    switch result {
                    case .success(let response):
                        do {                            
                            let res = try JSONDecoder.default.decode(D.self, from: response.data)
                            continuation.resume(returning: res)
                        }
                        catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error.asAPIError)
                    }
                }
            }
        }
        
        func request(_ endpoint: Target) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                provider.request(endpoint) { result in
                    switch result {
                    case .success:
                        continuation.resume(returning: ())
                    case .failure(let error):
                        continuation.resume(throwing: error.asAPIError)
                    }
                }
            }
        }
    }
    
    var async: MoyaConcurrency {
        MoyaConcurrency(provider: self)
    }
}
