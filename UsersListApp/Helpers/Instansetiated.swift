//
//  Instansetiated.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 4/16/19.
//  Copyright © 2019 Anatolii Zavialov. All rights reserved.
//

import Foundation
import UIKit

protocol Instansestiated {
    static func instansetiate() -> Self
}

extension Instansestiated where Self: UIViewController {
    static func instansetiate() -> Self {
        let id = String(describing: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        
        return vc as! Self
    }
}
