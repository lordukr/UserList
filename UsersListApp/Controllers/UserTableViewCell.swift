//
//  UserTableViewCell.swift
//  UsersListApp
//
//  Created by My mac on 10/18/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import SDWebImage
import UIKit
import DTModelStorage

class UserTableViewCell: UITableViewCell, ModelTransfer {
    typealias ModelType = User
    
    @IBOutlet private weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    var userAvatarImageURL: String? {
        didSet{
            guard let userAvatarImageURL = userAvatarImageURL else {
                return
            }

            guard let avatarURL = URL.init(string: userAvatarImageURL) else {
                return
            }
            
            userAvatarImageView.sd_setImage(with: avatarURL, completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        userAvatarImageView.image = nil
    }
}

extension UserTableViewCell {
    func update(with model: UserTableViewCell.ModelType) {
        userFullNameLabel.text = model.userFullName.userFullName().capitalized
        userPhoneNumberLabel.text = model.phoneNumber
        userAvatarImageURL = model.userPhotoURL.thumb
    }
}
