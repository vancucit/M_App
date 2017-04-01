//
//  NotificationTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewAvatr: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    var notification:Notification!{
        didSet{
            lblUserName.text = notification.createdBy.nameUser
            lblContent.text = notification.getMessage()
            if let userUrlStr = notification.createdBy.getThumnailAvatar(){
                let userUrl = URL(string: userUrlStr)
                imgViewAvatr.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
                
            }
            if(notification.typeNoti == notification.TYPE_REQUEST){
                var challenge = notification.objectNoti as! Challenge
                if challenge.endDate != nil {
                    print(" challenger date \(challenge.endDate!)")
                    lblTime.text = getDisplayDateTime(challenge.endDate!)
                }else{
                    lblTime.text = ""

                    print(" challenger date nil")
                }

            }else{
                lblTime.text = ""
            }

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
