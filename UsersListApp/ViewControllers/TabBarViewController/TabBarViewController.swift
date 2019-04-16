//
//  TabBarViewController.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 10/22/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import UIKit

enum TabBarView: Int {
    case users = 0
    case savedUsers = 1
}

protocol TabBarViewControllerDelegate {
    func setSelectedViewController(with viewType: TabBarView)
}

class TabBarViewController: UIViewController, Instansestiated {
    lazy var tabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        let usersVC = UsersTableViewController.instansetiate()
        usersVC.tabBarItem.image = UIImage(named: "usersTabBarItemInActive")
        usersVC.delegate = self
        let savedUsersVC = SavedUsersTableViewController.instansetiate()
        savedUsersVC.tabBarItem.image = UIImage(named: "savedUsersTabBarItemInActive")
        
        let controllers = [usersVC, savedUsersVC]
        tabBar.viewControllers = controllers.map({ UINavigationController(rootViewController: $0)
        })
        tabBar.selectedIndex = 0
        
        addChild(tabBar)
        tabBar.view.frame = view.frame
        view.addSubview(tabBar.view)
        didMove(toParent: self)
    }
}

extension TabBarViewController: TabBarViewControllerDelegate {
    func setSelectedViewController(with viewType: TabBarView) {
        tabBar.selectedIndex = viewType.rawValue
    }
    
    func setSelectedViewController(vc: UIViewController) {
        
    }
}

extension SavedUsersTableViewController: DetailsViewControllerDelegate {
    func didAddUser(vc: UIViewController) {
        navigationController?.popViewController(animated: false)
        delegate?.setSelectedViewController(with: .savedUsers)
    }
}
