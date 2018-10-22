//
//  TabBarViewController.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 10/22/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(showSavedTabBarItem), name: NSNotification.Name(rawValue: "AZTabBarRequestAction"), object: nil)
    }
    
    @objc func showSavedTabBarItem(sender: Notification) {
        selectedIndex = 1
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
