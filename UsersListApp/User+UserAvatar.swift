//
//  User+UserAvatar.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation

struct UserAvatar: Codable {
    var large: String
    var medium: String
    var thumb: String
    
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumb = "thumbnail"
    }
    
    func encode(_ encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(large, forKey: .large)
        try container.encode(medium, forKey: .medium)
        try container.encode(thumb, forKey: .thumb)
    }
    
    init(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        large = try container.decode(String.self, forKey: .large)
        medium = try container.decode(String.self, forKey: .medium)
        thumb = try container.decode(String.self, forKey: .thumb)
    }
}
