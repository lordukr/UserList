//
//  StorageService.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 10/20/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import UIKit
import RealmSwift

class StorageService: NSObject {
    let realm: Realm?
    let results: Results<StoredUser>?
    
    override init() {
        realm = try? Realm()
        results = try? Realm().objects(StoredUser.self).sorted(byKeyPath: "insertDate", ascending: true)
        
        super.init()
    }
}
