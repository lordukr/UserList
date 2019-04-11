//
//  TableViewController.swift
//  UsersListApp
//
//  Created by My mac on 10/18/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import DTModelStorage
import DTTableViewManager

class UsersTableViewController: UITableViewController, DTTableViewManageable {
    
    var selectedUser: User?
    let dataSource = UserDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        
        manager.configureEvents(for: UserTableViewCell.self) { [weak self] cellType, modelType in
            manager.register(cellType)
            manager.didSelect(cellType, { ( _, modelType, indexPath) in
                self?.selectedUser = modelType
                self?.performSegue(withIdentifier: "showDetailsSegue", sender: nil)
            })
        }
        
        dataSource.loadUsers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? DetailsViewController
        
        if let user = selectedUser {
            viewController?.selectedUser = user
            viewController?.isAdd = true
        } else {
            let alert = UIAlertController(title: "Error", message: "Failed to open user", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UsersTableViewController: UserDataSourceDelegate {
    func didLoadData() {
        self.manager.memoryStorage.addItems(dataSource.models)
    }
    
    func didFail(with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
