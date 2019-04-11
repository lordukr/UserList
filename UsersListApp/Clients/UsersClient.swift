//
//  UsersClient.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/10/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation
import Alamofire

class UsersClient: ApiClient {
    static func usersList(items: Int, page: Int, completion: @escaping (DataResponse<UsersListResponse>) -> Void) {
        performRequest(route: UsersApiRouter.users(count: items, page: page), completion: completion)
    }
}
