//
//  UserTableViewCell.swift
//  UsersListApp
//
//  Created by My mac on 10/18/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import SDWebImage
import UIKit

class UserTableViewCell: UITableViewCell {
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
        // Initialization code
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        userAvatarImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
