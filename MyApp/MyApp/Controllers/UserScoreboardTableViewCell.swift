//
//  UserScoreboardTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class UserScoreboardTableViewCell: UITableViewCell {

    //IBOutlet 
    @IBOutlet weak var lblRank: UILabel!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblFollowNumber: UILabel!
    
    @IBOutlet weak var lblPoints: UILabel!
    
    var user:User!{
        didSet{
            lblRank.text = String(user.currentRank)
//            lblPoints.text = String(user.point)
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
            if let userStr = user.getThumnailAvatar() {
                imgAvatar.sd_setImage(with: URL(string: userStr), placeholderImage: UIImage(named: "img_avatar_holder"))
            }else{
                imgAvatar.image = UIImage(named: "img_avatar_holder")

            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectionColor = UIView()
        selectionColor.backgroundColor = GlobalConstants.ColorConstant.DefaultSelectedColor
        self.selectedBackgroundView = selectionColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
