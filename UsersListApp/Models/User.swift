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
    
    init(with model: StoredUser) {
        let fullName = UserFullName(firstName: model.firstName, lastName: model.lastName)
        userFullName = fullName
        phoneNumber = model.phoneNumber
        userEmail = model.email
        let avatarModel = UserAvatar(with: model.avatarURLs?.large, thumb: model.avatarURLs?.thumbnail)
        userPhotoURL = avatarModel
    }
}

struct UserFullName: Codable {
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
    }
}

extension UserFullName {
    func userFullName() -> String {
        return firstName + " " + lastName
    }
}

struct UserAvatar: Codable {
    var large: String = ""
    var thumb: String = ""
    
    enum CodingKeys: String, CodingKey {
        case large
        case thumb = "thumbnail"
    }
    
    init(with large: String?, thumb: String?) {
        if let large = large {
            self.large = large
        }
        if let thumb = thumb {
            self.thumb = thumb
        }
    }
}
