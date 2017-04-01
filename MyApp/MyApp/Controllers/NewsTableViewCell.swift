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
    
    @IBOutlet var borderBtns: [UIButton]!
    @IBOutlet var borderView: UIView!
    @IBOutlet weak var imgViewAvatarUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblExpireOn: UILabel!
    @IBOutlet weak var lblToRecipients: UILabel!
    @IBOutlet weak var btnTotalLike: UIButton!
    @IBOutlet weak var btnTotalComment: UIButton!
    @IBOutlet weak var btnYourRate: UIButton!
    
    @IBOutlet weak var lblNumberResponse: UIButton!
    @IBOutlet var scrollViewUsers: UIScrollView!
    
    var challenge:Challenge?{
        didSet{
            lblUserName.text = challenge!.user?.nameUser
            imgViewAvatarUser.contentMode = .scaleToFill
            if let userImgStr = challenge!.user?.getThumnailAvatar() {
                if let userUrl = URL(string: userImgStr){
                    imgViewAvatarUser.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
                }
            }
            
            
            
            lblTime.text = getDisplayDateTime(challenge!.dateCreate!)
//            lblTime.text = shortStringFromDate(challenge!.dateCreate!)
            lblContent.text = challenge?.descriptionChallenge
            if challenge?.endDate != nil {
                lblExpireOn.text = getDisplayDateTimeExpireOn(challenge!.endDate!)    
            }
            
            
            /*
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
            
            */
//            btnTotalComment.setTitle(String(challenge!.commentCount) + " comment", for: UIControlState())
            lblNumberResponse.setTitle(String(challenge!.numberResponse) + " response", for: UIControlState())
            var i = 0
            for subView in scrollViewUsers.subviews {
                subView.removeFromSuperview()
            }
            
            for user in challenge!.participants {
                let originX = CGFloat(i) * 60 + 10
                let frameImage = CGRect(x: originX , y: 0, width: 50, height: 50)
                let userImageView =  AsyncImageView(frame: frameImage)
//                ConstantPipeFish.addRoundImageColor(userImageView)
                userImageView.layer.borderWidth = 2
//                userImageView.layer.borderColor = ConstantPipeFish.whiteColor.cgColor
//                AsyncImageLoader.shared().cancelLoadingImages(forTarget: userImageView)
                userImageView.isCircleImage = true
                userImageView.backgroundColor = UIColor.white
                
                if let userID = user.idUser as String?{
                    userImageView.tag = Int(userID)!
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewsTableViewCell.avatarUserTouched(_:)))
                    tapGesture.numberOfTapsRequired = 1
                    userImageView.addGestureRecognizer(tapGesture)
                    userImageView.isUserInteractionEnabled = true

                }
                
                userImageView.showActivityIndicator = true
                userImageView.layer.borderColor = UIColor.white.cgColor
                userImageView.layer.borderWidth = 1
                userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
                userImageView.clipsToBounds = true
                AsyncImageLoader.shared().cancelLoadingImages(forTarget: userImageView)
                if let userStr = user.getThumnailAvatar() {
                    userImageView.sd_setImage(with: URL(string: userStr), placeholderImage: UIImage(named: "img_avatar_holder"))
                    
                }else{
                    userImageView.image = UIImage(named: "img_avatar_holder")
                }
                
               
                
                scrollViewUsers.addSubview(userImageView)
                
                i += 1
            }
            scrollViewUsers.scrollsToTop = false
            scrollViewUsers.contentSize = CGSize( width: CGFloat(i) * 60 + 20 , height: 50)
        }
    }
    
    func avatarUserTouched(_ sender: Any){
        let gestureObject = sender as! UITapGestureRecognizer
        let userIDTap = gestureObject.view?.tag
        
        if(delegate != nil){
            delegate.willOpenProfileUser(String(userIDTap!))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.borderView.layer.borderColor = UIColor.gray.cgColor
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.cornerRadius = 3.0
        self.borderView.clipsToBounds = true
        
        //add gesture 
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewsTableViewCell.avatarImageTaped(_:)))
        imgViewAvatarUser.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 1
        imgViewAvatarUser.addGestureRecognizer(tapGesture)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightGray
         self.selectedBackgroundView = backgroundView
        
        for button in self.borderBtns {
            button.cornerButton()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        lblContent.setNeedsLayout()
        lblContent.layoutIfNeeded()
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
