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


class UsersTableViewController: UITableViewController {
    static let tableViewCellIdentifier = "tableViewIdentifier"
    
    var items: [User]? = Array.init()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        NetworkService.downloadUsersList(20, 1) { (usersList) in
            self.items = usersList?.items
            self.tableView.reloadData()
        }
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath) as? UserTableViewCell

        let user = items?[indexPath.row]
        
        cell?.userFullNameLabel.text = user?.userFullName.userFullName()
        cell?.userPhoneNumberLabel.text = user?.phoneNumber
        cell?.userAvatarImageURL = user?.userPhotoURL.thumb
        
        return cell!
    }
    
}
