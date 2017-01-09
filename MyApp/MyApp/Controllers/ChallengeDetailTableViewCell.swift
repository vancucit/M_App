//
//  FollowTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class ChallengeDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAvatarUser: UIImageView!

    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblContentMsg: UILabel!
    
    @IBOutlet weak var containResponseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
