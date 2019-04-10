//
//  SavedUsersTableViewController.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 10/18/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import UIKit
import RealmSwift

class SavedUsersTableViewController: UITableViewController {
    var selectedUser: StoredUser?
    var notificationToken: NotificationToken?
    var storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userTableViewCell")
        
        notificationToken = storageService.results?.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                print(err)
                break
            }
        })
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
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storageService.results?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath) as? UserTableViewCell
        let user = storageService.results?[indexPath.row]
        
        cell?.userFullNameLabel.text = user?.fullName().capitalized
        cell?.userPhoneNumberLabel.text = user?.phoneNumber
        cell?.userAvatarImageURL = user?.avatarURLString
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let objectToDelete = storageService.results?[indexPath.row] else {
                print("Unable to retrieve object from storage")
                return
            }
            
            storageService.realm?.beginWrite()
            storageService.realm?.delete(objectToDelete)
            do {
                try storageService.realm?.commitWrite()
            } catch {
                print("Unable to delete item:\(error)")
            }
        }
    }

    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedUser = storageService.results?[indexPath.row]
        
        performSegue(withIdentifier: "showDetailsSegue", sender: self)
    }
}
