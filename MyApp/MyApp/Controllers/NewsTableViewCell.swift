//
//  NewsTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
protocol NewsTableViewCellDelegate{
    func willOpenProfileUser(_ idStrin:String)
    func willRejectChallenger(_ idChallenger:String)
    func willReplyChallenge(_ idChallenger:String)
}
class NewsTableViewCell: UITableViewCell {
    var delegate:NewsTableViewCellDelegate!
    
    @IBOutlet weak var viewContentCell: UIView!
    
    @IBOutlet weak var imgViewAvatarUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblExpireOn: UILabel!
    @IBOutlet weak var lblToRecipients: UILabel!
    @IBOutlet weak var btnTotalLike: UIButton!
    @IBOutlet weak var btnTotalComment: UIButton!
    @IBOutlet weak var btnYourRate: UIButton!
    
    var challenge:Challenge?{
        didSet{
            lblUserName.text = challenge!.user?.nameUser
            let userUrl = URL(string: challenge!.user!.avatar)
            imgViewAvatarUser.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
            
            lblTime.text = getDisplayDateTime(challenge!.dateCreate!)
            lblContent.text = challenge?.descriptionChallenge
            lblExpireOn.text = getDisplayDateTime(challenge!.endDate!)
            
            var indexTag = 0
            var displayStr = ""
            for partic in challenge!.participants {
                if indexTag == 0 {
                    displayStr += partic.nameUser
                }else{
                    displayStr += ", " + partic.nameUser
                }
                indexTag += 1
            }
            lblToRecipients.text = displayStr
            
            btnTotalLike.setTitle(String(challenge!.totalRatedPoint), for: UIControlState())
            btnTotalComment.setTitle(String(challenge!.commentCount), for: UIControlState())
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContentCell.layer.borderColor = UIColor.gray.cgColor
        viewContentCell.layer.borderWidth = 1.0
        viewContentCell.layer.cornerRadius = 3.0
        viewContentCell.clipsToBounds = true
        
        //add gesture 
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewsTableViewCell.avatarImageTaped(_:)))
        imgViewAvatarUser.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 1
        imgViewAvatarUser.addGestureRecognizer(tapGesture)
    }

    func avatarImageTaped(_ sender:AnyObject!){
        if(delegate != nil){
            delegate.willOpenProfileUser(challenge!.user!.idUser)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func yourRateTouched(_ sender: AnyObject) {
    }
    
    @IBAction func rejectTouched(_ sender: AnyObject) {
        if(delegate != nil){
            delegate.willRejectChallenger(challenge!.idChallenge)
        }
    }
    
    @IBAction func shareTouched(_ sender: AnyObject) {
    }
    @IBAction func replyTouched(_ sender: AnyObject) {
        if(delegate != nil){
            delegate.willReplyChallenge(challenge!.idChallenge)
        }
    }
}
