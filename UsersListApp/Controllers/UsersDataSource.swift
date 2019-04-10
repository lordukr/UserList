//
//  UsersDataSource.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/5/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation

protocol UserDataSourceDelegate {
    func didLoadData()
    func didFail(with error: Error)
}

class UserDataSource {
    struct K {
        static let count = 100
    }
    
    var delegate: UserDataSourceDelegate?
    var page: Int = 1
    var models: [User] = [User]()
    
    func loadUsers() {
        UsersClient.usersList(items: K.count, page: page) { (response) in
            switch response.result {
            case .success(let result):
                self.models.append(contentsOf: result.items)
                self.delegate?.didLoadData()
            case .failure(let error):
                self.delegate?.didFail(with: error)
            }
        }
    }
}
