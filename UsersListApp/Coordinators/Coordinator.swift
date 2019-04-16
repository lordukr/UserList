//
//  Coordinator.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/16/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
