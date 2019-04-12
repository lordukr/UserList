//
//  UsersDataSource.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/5/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserDataSourceDelegate {
    func didLoadData()
    func didFail(with error: Error)
}

class UserDataSource {
    struct K {
        static let count = 100
    }
    
    var realm: Realm? {
        do {
            return try Realm()
        } catch {
            print("Failed to create Realm")
            print("Error: \(error)")
            
            return nil
        }
    }
    
    var delegate: UserDataSourceDelegate?
    var page: Int = 1
    var models: [User] = [User]()
    
    func loadUsers() {
        UsersClient.usersList(items: K.count, page: page) { (response) in
            switch response.result {
            case .success(let result):
                self.models.removeAll()
                self.models.append(contentsOf: result.items)
                self.delegate?.didLoadData()
            case .failure(let error):
                self.delegate?.didFail(with: error)
            }
        }
    }
    
    func loadLocalUsers() {
        guard let data = realm?.objects(StoredUser.self).sorted(byKeyPath: "insertDate", ascending: true) else {
            return
        }
        
        let items: [User] = data.map({ User(with: $0) })
        
        models.removeAll()
        models.append(contentsOf: items)
        delegate?.didLoadData()
    }
    
    func deleteUser(_ user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        let storedUser = realm?.objects(StoredUser.self).first(where: { $0.firstName == user.userFullName.firstName && $0.lastName == user.userFullName.lastName && $0.phoneNumber == user.phoneNumber})
        
        guard let user = storedUser else {
            completion(.failure(NSError(domain: "User not found", code: -098, userInfo: nil)))
            return
        }
        
        realm?.beginWrite()
        realm?.delete(user)
        do {
            try realm?.commitWrite()
        } catch let error {
            print(error)
            completion(.failure(NSError(domain: "Failed to delete user", code: -098, userInfo: nil)))
        }
        completion(.success(true))
    }
    
    func saveUser(_ user: User) {
        let localUser = StoredUser()
        localUser.firstName = user.userFullName.firstName
        localUser.lastName = user.userFullName.lastName
        localUser.phoneNumber = user.phoneNumber
        localUser.email = user.userEmail
        localUser.insertDate = Date()
        let avatarURLs = StoredImageURL()
        avatarURLs.large = user.userPhotoURL.large
        avatarURLs.thumbnail = user.userPhotoURL.thumb
        localUser.avatarURLs = avatarURLs
        
        let object = realm?.objects(StoredUser.self).first(where: { $0 == localUser })
        
        if let storedObject = object {
            realm?.beginWrite()
            storedObject.firstName = localUser.firstName
            storedObject.lastName = localUser.lastName
            if let thumb = localUser.avatarURLs?.thumbnail {
                storedObject.avatarURLs?.thumbnail = thumb
            }
            if let large = localUser.avatarURLs?.large {
                storedObject.avatarURLs?.large = large
            }
            
            storedObject.email = localUser.email
            do {
                try realm?.commitWrite()
            } catch let error {
                print(error)
            }
        } else {
            do {
                realm?.beginWrite()
                realm?.add(localUser)
                try realm?.commitWrite()
            } catch let error {
                print(error)
            }
        }
    }
}

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
