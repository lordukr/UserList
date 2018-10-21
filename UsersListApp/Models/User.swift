//
//  User.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation

class User: NSObject, Codable {
    var userFullName: UserFullName
    var phoneNumber: String
    var userPhotoURL: UserAvatar
    var userEmail: String
    
    enum CodingKeys: String, CodingKey {
        case userFullName = "name"
        case phoneNumber = "phone"
        case userPhotoURL = "picture"
        case userEmail = "email"
    }
}
