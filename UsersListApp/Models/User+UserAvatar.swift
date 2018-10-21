//
//  User+UserAvatar.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation

class UserAvatar: NSObject, Codable {
    var large: String
    var medium: String
    var thumb: String
    
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumb = "thumbnail"
    }
}
