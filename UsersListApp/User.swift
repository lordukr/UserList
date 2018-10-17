//
//  User.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation

struct User: Codable {
    var userFullName: UserFullName
    var phoneNumber: String
    var userPhotoURL: UserAvatar
    
    enum CodingKeys: String, CodingKey {
        case userFullName = "name"
        case phoneNumber = "phone"
        case userPhotoURL = "picture"
    }
    
    func encode(_ encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userFullName, forKey: .userFullName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(userPhotoURL, forKey: .userPhotoURL)
    }
    
    init(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userFullName = try container.decode(UserFullName.self, forKey: .userFullName)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        userPhotoURL = try container.decode(UserAvatar.self, forKey: .userPhotoURL)
    }
}
