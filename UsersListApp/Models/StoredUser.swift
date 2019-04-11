//
//  StoredUser.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 10/20/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import UIKit
import RealmSwift

class StoredUser: Object {
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var phoneNumber: String?
    @objc dynamic var email: String?
    @objc dynamic var avatarURLs: StoredImageURL?
    @objc dynamic var insertDate: Date?
}

extension StoredUser: Comparable {
    static func < (lhs: StoredUser, rhs: StoredUser) -> Bool {
        if lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && rhs.phoneNumber == lhs.phoneNumber {
            return true
        } else {
            return false
        }
    }
}

extension StoredUser {
    func fullName() -> String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
}
