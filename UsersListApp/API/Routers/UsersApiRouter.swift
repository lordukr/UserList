//
//  UsersApiRouter.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/10/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation
import Alamofire

enum UsersApiRouter: APIConfiguration {
    case users(count: Int, page: Int)
    
    var method: HTTPMethod {
        switch self {
        case .users:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .users(let count, let page):
            return "?page=\(page)&results=\(count)&nat=us"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .users:
            return nil
        }
    }
}
