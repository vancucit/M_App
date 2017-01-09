//
//  ChallengeView.swift
//  MyApp
//
//  Created by Cuc Nguyen on 5/4/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
protocol ChallengeViewDelegate{
    func willOpenProfileUser(_ idStrin:String)
    func willLikeResponse(_ idResponse:String)
    func willCommentResponse(_ challenger:Challenge)
    func willShareChallenger(_ challenger:Challenge)
    func willGoListUserLike(_ challenger:Challenge)
    func willSetPickerDelegate(_ picker:SBPickerSelector)
}
class ChallengeView: UIView, SBPickerSelectorDelegate {

    @IBOutlet weak var imgViewAvatarUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblExpireOn: UILabel!
    @IBOutlet weak var lblToRecipients: UILabel!
    @IBOutlet weak var btnTotalLike: UIButton!
    @IBOutlet weak var btnTotalComment: UIButton!
    @IBOutlet weak var btnYourRate: UIButton!
    
    @IBOutlet weak var lblYouRate: UILabel!
    @IBOutlet weak var lblTotalRate: UILabel!
    @IBOutlet weak var bottomRejectReplyShare: UIView!
    @IBOutlet weak var bottomLikeShare: UIView!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    
    @IBOutlet weak var bottomLikeCommentShare: UIView!
    
    var isDetailView = false{
        didSet{
            if(isDetailView){
                bottomRejectReplyShare.isHidden = true
                bottomLikeShare.isHidden = false
            }else{
                bottomLikeShare.isHidden = true
            }
        }
    }
    //MARK: property
    var challenge:Challenge?{
        didSet{
            lblUserName.text = challenge!.user?.nameUser
            let userUrl = URL(string: challenge!.user!.avatar)
            imgViewAvatarUser.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
            
            lblTime.text = getDisplayDateTime(challenge!.dateCreate!)
            lblContent.text = challenge?.descriptionChallenge
            if(challenge?.endDate != nil){
                lblExpireOn.text = getDisplayDateTime(challenge!.endDate!)
            }

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
            
            let suffixLikeStr = (challenge!.likeCount > 1) ? " likes" : " like "
            let suffixCommentStr = (challenge!.commentCount > 1) ? " comments" : " comment"
            
            btnTotalLike.setTitle(String(challenge!.likeCount) + suffixLikeStr, for: UIControlState() )
            btnTotalComment.setTitle(String(challenge!.commentCount) + suffixCommentStr, for: UIControlState())
            if challenge!.isSentToCurrentUser {
                if challenge!.isRateByCurrentUser == true{
                    btnYourRate.isEnabled = false
                }else{
                    btnYourRate.isEnabled = true
                }
                btnYourRate.isHidden = false
                lblYouRate.text = "Your rates: "
                lblTotalRate.isHidden = false
            }else{
                btnYourRate.isHidden = true
                lblYouRate.text = ""
                lblTotalRate.isHidden = true
            }

            btnYourRate.setTitle(String(challenge!.ratedByCurrentUser), for: UIControlState())
            
            lblTotalRate.text = "Total rate: " + String(challenge!.totalRatedPoint)
            
        }
    }
    var delegate:ChallengeViewDelegate?
    
    //MARK: IBAction
    
    func avatarImageTaped(_ sender:AnyObject!){
        if(delegate != nil){
            delegate!.willOpenProfileUser(challenge!.user!.idUser)
        }
    }
    @IBAction func yourRateTouched(_ sender: AnyObject) {
        let picker: SBPickerSelector = SBPickerSelector.picker()
        picker.pickerData = ["0","1","2","3","4","5"] //picker content
        picker.delegate = self
        picker.pickerType = SBPickerSelectorType.text
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
        
        delegate?.willSetPickerDelegate(picker)
//        picker.showPickerOver(delegate) //classic picker display
    }
    
    @IBAction func rejectTouched(_ sender: AnyObject) {
        if(delegate != nil){
//            delegate.willRejectChallenger(challenge!.idChallenge)
        }
    }
    
    @IBAction func shareTouched(_ sender: AnyObject) {
        if (delegate != nil){
            delegate!.willShareChallenger(self.challenge!)
        }
    }
    @IBAction func replyTouched(_ sender: AnyObject) {
        if(delegate != nil){
//            delegate.willReplyChallenge(challenge!.idChallenge)
        }
    }

    @IBAction func likeBtnTouched(_ sender: AnyObject) {
        var viewLike = sender as! UIButton
        MBProgressHUD.showAdded(to: viewLike, animated: true)
        AppRestClient.sharedInstance.likeChallenger(self.challenge!.idChallenge!, challengerID: challenge!.challengeReceivedID!) { (success, error) -> () in
//            if (success){
                viewLike.backgroundColor = UIColor.gray
                viewLike.isEnabled = false
                self.challenge!.isLikeByCurrentUser = true
//            }
            MBProgressHUD.hideAllHUDs(for: viewLike, animated: true)
        }
    }
    
    @IBAction func commentTouched(_ sender: AnyObject) {
        if (self.delegate != nil){
            self.delegate?.willCommentResponse(challenge!)
        }
    }

    @IBAction func totalLikeTouched(_ sender: AnyObject) {
        if(delegate != nil){
            delegate!.willGoListUserLike(challenge!)
        }
    }
    func heightContraintChallengerView()-> CGFloat {
//        print("height text : \(lblContent.text) heigh : \(lblContent.sizeOfMultiLineLabel().height)")
        return lblContent.sizeOfMultiLineLabel().height + 360
    }
    //MARK: life circle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        viewContentCell.layer.borderColor = UIColor.grayColor().CGColor
//        viewContentCell.layer.borderWidth = 1.0
//        viewContentCell.layer.cornerRadius = 3.0
//        viewContentCell.clipsToBounds = true
//        
        btnYourRate.layer.borderColor = UIColor.gray.cgColor
        btnYourRate.layer.borderWidth = 1.0
        btnYourRate.layer.cornerRadius = 3.0
        //add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChallengeView.avatarImageTaped(_:)))
        imgViewAvatarUser.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 1
        imgViewAvatarUser.addGestureRecognizer(tapGesture)
    }
    
    //MARK: SBPickerSelector delegate
    //if your piker is a traditional selection
    func pickerSelector(_ selector: SBPickerSelector!, selectedValue value: String!, index idx: Int){
        print("pickerSelector selectedvalue")
//        if challenge.ra
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.btnYourRate.isEnabled = false
            AppRestClient.sharedInstance.rateChallenge(challenge!.user!.idUser, challengeID: challenge!.idChallenge, rate: Int(value!)!) { (success, error) -> () in
            if error == nil {
                self.btnYourRate.isEnabled = false
                self.btnYourRate.setTitle(value, for: UIControlState())
            }else{
                self.btnYourRate.isEnabled = true
            }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    //when picker value is changing
    func pickerSelector(_ selector: SBPickerSelector!, intermediatelySelectedValue value: AnyObject!, at idx: Int)
    {
                print("pickerSelector intermediatelySelectedValue ")
    }
    func pickerSelector(_ selector: SBPickerSelector!, cancelPicker cancel: Bool){
        
    }
}
