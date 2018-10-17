//
//  File.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation

struct UsersListResponse: Decodable {
    let items: [User]
    
    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}
