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
import DZNEmptyDataSet
import DTModelStorage
import DTTableViewManager

class UsersTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, DTTableViewManageable {
    let amountOfItemsToLoad = 20
    var page: Int = 1
    var isLoading = false

    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        manager.configureEvents(for: UserTableViewCell.self) { [weak self] cellType, modelType in
            manager.register(cellType)
            manager.didSelect(cellType, { ( _, modelType, indexPath) in
                self?.selectedUser = modelType
                self?.performSegue(withIdentifier: "showDetailsSegue", sender: nil)
            })
        }
        
        loadItems(page)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? DetailsViewController
        
        if let user = selectedUser {
            let storedUser = StoredUser()
            storedUser.firstName = user.userFullName.firstName
            storedUser.lastName = user.userFullName.lastName
            storedUser.avatarURLString = user.userPhotoURL.medium
            storedUser.email = user.userEmail
            storedUser.phoneNumber = user.phoneNumber
            
            viewController?.selectedUser = storedUser
            viewController?.isAdd = true
        } else {
            let alert = UIAlertController(title: "Error", message: "Failed to open user", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadItems(_ page: Int) {
        isLoading = true
        NetworkService().downloadUsersList(amountOfItemsToLoad, page) { (result) in
            self.isLoading = false
            switch result {
            case .success(let result):
                self.manager.memoryStorage.addItems(result.items)
            case .failure(let error):
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - DZNEmptyDataSetSource
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Data"
        
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.black]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        if isLoading {
            return false
        } else {
            return true
        }
    }
    
    func emptyDataSetDidAppear(_ scrollView: UIScrollView!) {
        tableView.separatorStyle = .none
    }
    
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView!) {
        tableView.separatorStyle = .singleLine
    }
    
    //MARK: - UITableViewDelegate
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let user = items[indexPath.row]
//        selectedUser = user
//
//        performSegue(withIdentifier: "showDetailsSegue", sender: nil)
//    }
//
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == items.count - 3 && isLoading == false {
//            loadItems(page)
//        }
//    }
    
    //MARK: - UITableViewDataSource
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath) as? UserTableViewCell else {
//            return UITableViewCell()
//        }
//
//        let user = items[indexPath.row]
//
//
//        return cell
//    }
    
}
