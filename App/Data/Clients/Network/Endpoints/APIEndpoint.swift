//
//  APIEndpoint.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import Moya
import Foundation

enum APIEndpoint: TargetType {
    
    case login(LoginEmailRequest)
    
    case products
    case productsWithCategory(ProductsWithCategoryRequest)
    case product(ProductRequest)
    
    case users
    
    var baseURL: URL {
        return URL(string: Configuration.current.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "auth/login"
            
        case .products:
            return "products"
        case .productsWithCategory(let request):
            return "products/category/\(request.category)"
        case .product(let request):
            return "products/\(request.id)"
            
        case .users:
            return "users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
            
        case .products, .productsWithCategory, .product:
            return .get
            
        case .users:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(let request):
            let parameters = try! DictionaryEncoder().encode(request)
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        default:
            return .requestPlain
        }
    }
    
    static let defaultHeaders: [String: String] = {
        var headers = [String: String]()
        headers["X-API-VERSION"] = Configuration.current.apiVersion
        headers["X-DEVICE-TYPE"] = "i"
        headers["X-TIMEZONE-OFFSET"] = Configuration.current.timezoneOffset
        return headers
    }()
    
    var headers: [String : String]? {
        switch self {
        default:
            return APIEndpoint.defaultHeaders
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

// MARK - AccessTokenAuthorizable

extension APIEndpoint: AccessTokenAuthorizable {
    
    public var authorizationType: AuthorizationType? {
        switch self {
        case .login:
            return .none

        default:
            return .bearer
        }
    }
}
