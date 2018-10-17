//
//  NetworkService.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation
import Alamofire

typealias NetworkServiceResponse = ((UsersListResponse?) -> Void)?

class NetworkService: NSObject {
    
    class func downloadUsersList(_ count: Int, _ page: Int, _ completionBlock: NetworkServiceResponse) {
        let params = ["results" : count, "page" : page]
        
        Alamofire.request("https://randomuser.me/api/", parameters: params, encoding: URLEncoding(destination: .methodDependent)).responseJSON { response in
            
            switch response.result {
            case .success:
                guard let data = response.data else {
                    completionBlock?(nil)
                    return
                }
                let users = try! JSONDecoder().decode(UsersListResponse.self, from: data)
                
                completionBlock?(users)
            case .failure:
                completionBlock?(nil)
            }
        }
    }
}
