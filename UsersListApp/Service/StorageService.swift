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
    var realm: Realm? {
        do {
            return try Realm()
        } catch {
            print("Failed to create Realm")
            print("Error: \(error)")
            
            return nil
        }
    }

    var results: Results<StoredUser>? {
        get {
            return self.realm?.objects(StoredUser.self).sorted(byKeyPath: "insertDate", ascending: true)
        }
    }
}
