//
//  User+UserFullName.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation

class UserFullName: NSObject, Codable {
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
