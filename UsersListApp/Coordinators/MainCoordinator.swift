//
//  MainCoordinator.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/16/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    func start() {
        let vc = TabBarViewController()
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    init() {
        navigationController = UINavigationController()
    }
}
