//
//  User.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation
import DTModelStorage

struct User: Codable {
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

struct UserFullName: Codable {
    var title: String
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case firstName = "first"
        case lastName = "last"
    }
}

extension UserFullName {
    func userFullName() -> String {
        return title + "." + firstName + " " + lastName
    }
}

struct UserAvatar: Codable {
    var large: String
    var thumb: String
    
    enum CodingKeys: String, CodingKey {
        case large
        case thumb = "thumbnail"
    }
}
