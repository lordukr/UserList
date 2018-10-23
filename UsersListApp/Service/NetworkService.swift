//
//  NetworkService.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation
import Alamofire

typealias NetworkServiceResponse = ((_ response: UsersListResponse?,_ error: Error?) -> Void)?

class NetworkService: NSObject {
    
    func downloadUsersList(_ count: Int, _ page: Int, _ completionBlock: NetworkServiceResponse) {
        let params = ["results" : count, "page" : page]
        
        Alamofire.request("https://randomuser.me/api/", parameters: params, encoding: URLEncoding(destination: .methodDependent)).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    let error = NSError(domain: "Missing data for response", code: response.response?.statusCode ?? 500, userInfo: nil)
                    completionBlock?(nil, error)
                    return
                }
                
                let users = try? JSONDecoder().decode(UsersListResponse.self, from: data)
                
                completionBlock?(users, nil)
            case .failure:
                completionBlock?(nil, response.error)
            }
        }
    }
}
