//
//  ApiConfiguration.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/9/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String]? { get }
    var parameters: Parameters? { get }
    func asURLRequest() throws -> URLRequest
}

extension APIConfiguration {
    var header: [String: String]? { return nil }
}

extension APIConfiguration {
    
    func asURLRequest() throws -> URLRequest {
        let url = API.kProductionServer.baseURL + API.kProductionServer.api
        print(url)
        guard let fullUrlString = url.appending(path).removingPercentEncoding,
            let fullUrl = URL(string: fullUrlString) else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
        }
        
        var urlRequest = URLRequest(url: fullUrl)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if let header = header, let key = header.keys.first {
            urlRequest.setValue(header.values.first, forHTTPHeaderField: key)
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
