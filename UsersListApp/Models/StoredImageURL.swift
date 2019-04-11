//
//  StoredImageURL.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/11/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation
import RealmSwift

class StoredImageURL: Object {
    @objc dynamic var thumbnail: String?
    @objc dynamic var large: String?
}
