//
//  ResponseView.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/27/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
protocol ResponseViewDelegate{
    func willReloadTableView()
    func willGoToResponseOriginal(_ challengerID:String)
    func willGoToResponseOriginalChallenger(_ challenger:Challenge)

    func willGotoCommentResponse(_ response:Response)
    func willGotoResponse(_ response:Response)
    func willGotoListUserLikeResponse(_ response:Response)
    func willShareResponse(_ response:Response)
    func willSetPickerDelegate(_ picker:SBPickerSelector)

}
class ResponseView: UIView, SBPickerSelectorDelegate  {
    let defaultHeight:CGFloat = 600
    @IBOutlet weak var widthItemConstrant: NSLayoutConstraint!
    @IBOutlet weak var imgViewAvatar: UIImageView!
    
    @IBOutlet weak var btnRateResponse: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblTimeAgo: UILabel!
    
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var containResponseView: UIView!
    @IBOutlet weak var imgResponse: UIImageView!
    @IBOutlet weak var lblTextRepsone: UILabel!
    
    @IBOutlet weak var viewBottomResponseGeneral: UIView!

    
    
    @IBOutlet weak var btnNumLike: UIButton!
    
    @IBOutlet weak var btnNumComment: UIButton!
    
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var heightLblContentConstrant: NSLayoutConstraint!
    @IBOutlet weak var heightImgResponse: NSLayoutConstraint!
    @IBOutlet weak var heightContainResponseView: NSLayoutConstraint!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var originalBtn: UIButton!
    var delegate:ResponseViewDelegate?
    
    var isHasReloadTableView = false
    
    var isDetailView:Bool = false{
        didSet{
            if isDetailView {

                (UIScreen.main.bounds.size.width/2 - 20 )
//                widthItemConstrant.constant = (UIScreen.main.bounds.size.width/2 - 20 )
                btnComment.isHidden = true
                
            }else{
                btnComment.isHidden = false
//                widthItemConstrant.constant = (UIScreen.main.bounds.size.width/3 - 20 )
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        btnLike.cornerButton()
        btnComment.cornerButton()
        btnShare.cornerButton()
        originalBtn.cornerButton()
    }
    var originalHidden = false{
        didSet{
            originalBtn.isHidden = originalHidden
        }
    }
    var response:Response!{
        didSet{
            if let urlStr  = response!.user!.getThumnailAvatar(){
                let userUrl = URL(string: urlStr)
                imgViewAvatar.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
            }
            
            
            lblUserName.text = response.user?.nameUser

            lblTimeAgo.text = getDisplayDateTime(response!.postedOn!)

           lblTextRepsone.preferredMaxLayoutWidth = imgResponse.frame.size.width
            lblTextRepsone.text = response.comment
            heightLblContentConstrant.constant =  lblTextRepsone.sizeOfMultiLineLabel().height

            self.heightLblContentConstrant.constant =  self.lblTextRepsone.sizeOfMultiLineLabel().height
            
            self.heightContainResponseView.constant = 100 + self.heightImgResponse.constant + self.heightLblContentConstrant.constant
            if(response.photoUrl != nil){
                let urlResponse = URL(string: response!.photoUrl!)
                imgResponse.setImageWith(urlResponse, completed: { (image, error, cachtype, urlResponse) -> Void in
                    self.imgResponse.image = image
                    var widthImage:CGFloat = UIScreen.main.bounds.width - 20.0
                    self.heightLblContentConstrant.constant =  self.lblTextRepsone.sizeOfMultiLineLabel().height
                    
                    self.heightContainResponseView.constant = 100 + self.heightImgResponse.constant + self.heightLblContentConstrant.constant
                    
                    if(!self.isHasReloadTableView){
                        if (self.delegate != nil){
                            self.delegate!.willReloadTableView()
                            self.isHasReloadTableView = true
                           
                        }                        
                    }
                }, usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            }
            let suffixLikeStr = (response!.likeCount > 1) ? " likes" : " like "
            let suffixCommentStr = (response!.commentCount > 1) ? " comments" : " comment"
            btnNumLike.setTitle(String(response!.likeCount) + suffixLikeStr, for: UIControlState() )
            btnNumComment.setTitle(String(response!.commentCount) + suffixCommentStr, for: UIControlState())

            if(response.isLikeByCurrentUser){
                btnLike.backgroundColor = UIColor.lightGray
                btnLike.isEnabled = false
            }else{
                btnLike.backgroundColor = GlobalConstants.ColorConstant.DefaultSelectedColor
                btnLike.isEnabled = true
            }
            if response.challenger != nil {
                if response.challenger!.isSentToCurrentUser {
                    btnRateResponse.isHidden = false
                    if response!.isRate {
                        btnRateResponse.isEnabled = false
                        btnRateResponse.layer.cornerRadius = 0.0
                        btnRateResponse.layer.borderWidth = 0.0

                        btnRateResponse.setTitle("Rate: " + String(response.rate), for: UIControlState())
                        btnRateResponse.setTitleColor(UIColor.gray, for: UIControlState())
                    }else{
                        btnRateResponse.isEnabled = true
                        btnRateResponse.clipsToBounds = true
                        btnRateResponse.layer.cornerRadius = 3.0
                        btnRateResponse.layer.borderWidth = 1.0
                        btnRateResponse.layer.borderColor = UIColor.gray.cgColor
                        btnRateResponse.setTitleColor(UIColor.black, for: UIControlState())
                        btnRateResponse.setTitle("Rate: 0", for: UIControlState())
                    }
                }else{
                    btnRateResponse.isHidden = true

                }
            }else{
                btnRateResponse.isHidden = true
            }
            
        }
    }
    func heightOfResponseView()->CGFloat{
        return self.heightContainResponseView.constant + 140
        //bottom is 200, top is 90
    }

    //MARK: IBAction
    @IBAction func responseTouched(_ sender: AnyObject) {
        if(self.delegate != nil){
            self.delegate?.willGotoResponse(response)
        }
    }
    @IBAction func rateTouched(_ sender: AnyObject) {
        print("Enalbe rate ")
        let picker: SBPickerSelector = SBPickerSelector.picker()
        picker.pickerData = ["0","1","2","3","4","5","6","7","8","9","10"] //picker content
        picker.delegate = self
        picker.pickerType = SBPickerSelectorType.text
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
        
        delegate?.willSetPickerDelegate(picker)
    }
    
    @IBAction func showOriginalChallengerTouched(_ sender: AnyObject) {
        
        if (self.delegate != nil){
            if(response.challenger != nil){
                self.delegate?.willGoToResponseOriginalChallenger(response.challenger!)
            }else{
            self.delegate?.willGoToResponseOriginal(response.challengerID!)
            }
            
        }
    }
    
    @IBAction func gotoCommentTouched(_ sender: AnyObject) {
        if(self.delegate != nil){
            self.delegate!.willGotoCommentResponse(response)
        }
    }
    @IBAction func btnNumLikeTouched(_ sender: AnyObject) {
        if(delegate != nil){
            delegate!.willGotoListUserLikeResponse(response!)
        }
    }
    
    
    @IBAction func btnNumCommentTouched(_ sender: AnyObject) {
        
    }
    
    @IBAction func likeTouched(_ sender: AnyObject) {
        MBProgressHUD.showAdded(to: self.btnLike, animated: true)
        AppRestClient.sharedInstance.likeResponse(true, responseID: response.idResponse) { (success, error) -> () in
            if (success){
              
            }
            self.btnLike.backgroundColor = UIColor.lightGray
            self.btnLike.isEnabled = false
            self.response.isLikeByCurrentUser = true
            MBProgressHUD.hideAllHUDs(for: self.btnLike, animated: true)
        }
    }
    @IBAction func shareTouched(_ sender: AnyObject) {
        if (delegate != nil){
            delegate?.willShareResponse(response)
        }
    }
    
    //MARK: SBPickerSelector delegate
    //if your piker is a traditional selection
    func pickerSelector(_ selector: SBPickerSelector!, selectedValue value: String!, index idx: Int){
        print("pickerSelector selectedvalue")
        //        if challenge.ra
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.btnRateResponse.isEnabled = false
        self.btnRateResponse.setTitle("Rate: " + value, for: UIControlState())
        
        AppRestClient.sharedInstance.rateResponse(response.idResponse, rate: Int(value)!) { (success, error) -> () in
            if error == nil {
                self.response.rate = Int(value)!
                self.btnRateResponse.layer.cornerRadius = 0.0
                self.btnRateResponse.layer.borderWidth = 0.0
                
                self.btnRateResponse.setTitle("Rate: " + value, for: UIControlState())
                self.btnRateResponse.setTitleColor(UIColor.gray, for: UIControlState())
            }else{
                self.btnRateResponse.isEnabled = true
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
