//
//  UserTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 5/26/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblFollowNumber: UILabel!
    
    
    var user:User!{
        didSet{
            lblUserName.text = user.nameUser
            var followingStr = " following, "
            if(user.followingCount > 1){
                followingStr = " followings, "
            }
            var followerStr = " follower"
            if(user.followerCount > 1){
                followerStr = " followers"
            }
            lblFollowNumber.text = String(user.followingCount) + followingStr + String(user.followerCount) + followerStr
            
            imgAvatar.sd_setImage(with: URL(string: user.avatar), placeholderImage: UIImage(named: "img_avatar_holder"))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
