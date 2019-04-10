//
//  ApiClient.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/9/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Alamofire

class ApiClient {
    static func performRequest<T: Decodable>(route: APIConfiguration, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (DataResponse<T>) -> Void) {
        AF.request(route).validate(statusCode: 200..<299).responseDecodable(decoder: decoder, completionHandler: completion)
    }
    
    static func performRequest(route: APIConfiguration, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (DataResponse<Any>) -> Void) {
        AF.request(route).validate(statusCode: 200..<299).responseJSON(completionHandler: completion)
    }
}
