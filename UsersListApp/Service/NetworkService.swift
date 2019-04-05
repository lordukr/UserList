//
//  NetworkService.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation
import Alamofire

//typealias NetworkServiceResponse = (_ response: @escaping (Result<UsersListResponse, Error>) -> Void?)

class NetworkService: NSObject {
    
    func downloadUsersList(_ count: Int, _ page: Int, _ completion: ((Result<UsersListResponse>) -> Void)?) {
        let params = ["results" : count, "page" : page]
        
        Alamofire.request("https://randomuser.me/api/", parameters: params, encoding: URLEncoding(destination: .methodDependent)).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    let error = NSError(domain: "Missing data for response", code: response.response?.statusCode ?? 500, userInfo: nil)
                    completion?(.failure(error))
                    return
                }
                do {
                    let users = try JSONDecoder().decode(UsersListResponse.self, from: data)
                    completion?(.success(users))
                } catch let error {
                    completion?(.failure(error))
                }
            case .failure:
                completion?(.failure(response.error ?? NSError(domain: "Something went wrong", code: -999, userInfo: nil)))
            }
        }
    }
}
