//
//  SavedUsersTableViewController.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 10/18/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import UIKit
import DTTableViewManager

class SavedUsersTableViewController: UITableViewController, Instansestiated, DTTableViewManageable {
    
    var selectedUser: User?
    var delegate: TabBarViewControllerDelegate?
    
    let dataSource = UserDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        
        manager.configureEvents(for: UserTableViewCell.self) { [weak self] cellType, modelType in
            manager.register(cellType)
            manager.didSelect(cellType, { ( _, modelType, indexPath) in
                self?.selectedUser = modelType
                self?.showDetailsVC()
            })
            manager.trailingSwipeActionsConfiguration(for: cellType, { ( _, modelType, indexPath) -> UISwipeActionsConfiguration? in
                
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { (handler, view, completionHandler) in
                    self?.dataSource.deleteUser(modelType, completion: { (result) in
                        switch result {
                        case .success(_):
                            completionHandler(true)
                        case .failure(_):
                            completionHandler(false)
                        }
                    })
                }
                deleteAction.image = UIImage(named: "delete")
                deleteAction.backgroundColor = .red
                
                return UISwipeActionsConfiguration(actions: [deleteAction])
            })
        }
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource.getLocalUsers()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? DetailsViewController
        
        if let user = selectedUser {
            viewController?.selectedUser = user
            viewController?.isAdd = false
        } else {
            let alert = UIAlertController(title: "Error", message: "Failed to open user", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)

            present(alert, animated: true, completion: nil)
        }
    }
    
    func showDetailsVC() {
        let vc = DetailsViewController.instansetiate()
        vc.delegate = self
        vc.selectedUser = selectedUser
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SavedUsersTableViewController: UserDataSourceDelegate {
    func didLoadData() {
        manager.memoryStorage.removeAllItems()
        manager.memoryStorage.addItems(dataSource.models)
    }
    
    func didFail(with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
