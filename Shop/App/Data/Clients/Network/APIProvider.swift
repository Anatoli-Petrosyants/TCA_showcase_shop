//
//  APIProvider.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import Foundation
import Moya

struct API {
    static let provider = MoyaProvider<APIEndpoint>(session: defaultSession(),
                                                    plugins: [
                                                        NetworkLoggerPlugin(
                                                            configuration: .init(logOptions: .verbose)
                                                        ),
                                                        AccessTokenPlugin {_ in "jwt_token"}])
    
    static private func defaultSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 30.0
        configuration.headers = .default
        return Session(configuration: configuration, startRequestsImmediately: false)
    }
}
