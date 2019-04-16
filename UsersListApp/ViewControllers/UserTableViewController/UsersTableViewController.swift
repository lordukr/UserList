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

class UsersTableViewController: UITableViewController, Instansestiated, DTTableViewManageable {
    
    var selectedUser: User?
    let dataSource = UserDataSource()
    var delegate: TabBarViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        
        manager.configureEvents(for: UserTableViewCell.self) { [weak self] cellType, modelType in
            manager.register(cellType)
            manager.didSelect(cellType, { ( _, modelType, indexPath) in
                self?.selectedUser = modelType
                self?.showDetailsVC()
            })
        }
        
        dataSource.getUsers()
    }
    
    func showDetailsVC() {
        let vc = DetailsViewController.instansetiate()
        vc.delegate = self
        if let user = selectedUser {
            vc.selectedUser = user
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UsersTableViewController: UserDataSourceDelegate {
    func didLoadData() {
        manager.memoryStorage.addItems(dataSource.models)
    }
    
    func didFail(with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension UsersTableViewController: DetailsViewControllerDelegate {
    func didAddUser(vc: UIViewController) {
        
        navigationController?.popViewController(animated: true)
        self.delegate?.setSelectedViewController(with: .savedUsers)
    }
}
