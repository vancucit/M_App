//
//  NewFeedDetailViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 5/11/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class NewFeedDetailViewController: BaseKeyboardViewController,UITableViewDelegate, UITableViewDataSource,FBSDKSharingDelegate,ChallengeViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containResponseView: UIView!
    @IBOutlet weak var containChallengeView: UIView!
    @IBOutlet weak var txtViewContent: UIPlaceHolderTextView!
    
    @IBOutlet weak var btnSendMsg: UIButton!
    var challengeView: ChallengeView!
    var responseView: ResponseView!
    
    @IBOutlet weak var heightChallengeConstant: NSLayoutConstraint!
    @IBOutlet weak var heightResponseConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var newFeed:NewFeed? {
        didSet{
            if let response = newFeed!.getItem() as? Response {
                challenger = response.challenger!
            }else{
                challenger = newFeed?.getItem() as! Challenge!
            }
            
        }
    }
    
    var challenger:Challenge!
    var isNeedShowComment = false
    var comments = [Response]()

    var currentPageIndex = 0
    var hasLoadMore = true
    var isLoading = false
    var isNeedReloadData = false

    //MARK - life cirlce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.updateUI()
        //TODO
        loadCommenst()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    
        self.setTitleNavigationBar("Detail Challenger")
    }

    
    //MARK:  ui
    func updateUI(){
        txtViewContent.layer.borderColor = UIColor.gray.cgColor
        txtViewContent.clipsToBounds = true
        
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 2.0
        if (challengeView == nil){
            if let aChallengeView = UIView.loadFromNibNamed("ChallengeView") as? ChallengeView{
                self.challengeView = aChallengeView
                self.challengeView.isDetailView = true
                self.challengeView.translatesAutoresizingMaskIntoConstraints = false
                
            }
        }
        self.containChallengeView.addSubview(self.challengeView)
        self.challengeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.containChallengeView).offset(0)
            make.left.equalTo(self.containChallengeView).offset(0)
            make.right.equalTo(self.containChallengeView).offset(0)
            make.bottom.equalTo(self.containChallengeView).offset(0)
        }
        
        self.challengeView.challenge = self.challenger
        self.challengeView.delegate = self
    }
    
    //MARK: IBAction
    
    @IBAction func sendMsgTouched(_ sender: AnyObject) {
        if (txtViewContent.text.characters.count == 0){
            return
        }
        
        self.showHudLoadingInView(self.btnSendMsg)
        AppRestClient.sharedInstance.sendResponse(self.challenger.idChallenge , comment: txtViewContent.text, photoUrl: "", isResonse: false) { (success, error) -> () in
            if (success != nil){
                self.resetAllData()
                self.loadCommenst()
                self.txtViewContent.text = ""
            }else{
                self.showDialog("", contentStr: "Send response failured. ")
            }
            self.hideHudLoadingInView(self.btnSendMsg)
        }
    }
    //MARK: - helper data
    func resetAllData(){
        isLoading = false
        hasLoadMore = true
        currentPageIndex = 0
        isNeedReloadData = true

    }
    func loadCommenst(){
        if (isLoading || !hasLoadMore){
            return
        }
        showHudLoadingInView(self.tableView)
        AppRestClient.sharedInstance.getResponsesForChallenge(challenger.idChallenge, pageIndex: currentPageIndex) { (responseLoad, error) -> () in
            if (self.isNeedReloadData){
                self.comments.removeAll(keepingCapacity: false)
                self.isNeedReloadData = false
            }
            if((responseLoad) != nil){
                self.currentPageIndex += 1
                for aMessage in responseLoad!{
                    self.comments.insert(aMessage, at: 0)
                }
                self.hasLoadMore = responseLoad?.count == AppRestClient.sharedInstance.Page_Count
                self.tableView.reloadData()
                self.scrollToBottom()

            }
            self.isLoading = false
            self.hideHudLoadingInView(self.tableView)
            self.tableView.reloadData()
            if(self.isNeedShowComment){
                self.txtViewContent.becomeFirstResponder()
                self.isNeedShowComment = false
            }

        }
    }
    func scrollToBottom(){
        if(self.comments.count > 0){
            self.tableView.scrollToRow(at: IndexPath(row: self.comments.count-1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    //MARK: - UITableViewDelegate, UITableViewDatasource
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
//        return self.heightForBasicCellAtIndexPath(indexPath)
//    }
//    func heightForBasicCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
//        return 80
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeDetailTableViewCellID", for: indexPath) as! ChallengeDetailTableViewCell
        cell.lblContentMsg.text = comment.comment
        cell.lblUserName.text = comment.user?.nameUser
        cell.lblTimeAgo.text = getDisplayDateTime(comment.postedOn!)

        let userUrl = URL(string: comment.user!.getThumnailAvatar()!)
        cell.imgAvatarUser.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
        return cell
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count;
    }
    //MARK: ChallengerViewDelegate
    func willOpenProfileUser(_ idString:String){
        let userProfileVC = storyboard!.instantiateViewController(withIdentifier: "UserProfileViewControllerID") as! UserProfileViewController;
        userProfileVC.idUser = idString
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    func willLikeResponse(_ idResponse:String){
        
    }
    func willGoListUserLike(_ challenger: Challenge) {
        let listUserLikeVC = storyboard!.instantiateViewController(withIdentifier: "ListUserLikeViewControllerID") as! ListUserLikeViewController
        listUserLikeVC.challengerID = challenger.idChallenge
        self.navigationController?.pushViewController(listUserLikeVC, animated: true)
    }
    func willCommentResponse(_ challenger:Challenge){
    }
    func willShareChallenger(_ challenger:Challenge){
        let content = FBSDKShareLinkContent()
        content.contentTitle =  "MApp is a social gameing app"
        content.contentURL = URL(string: "http://mapp1.azurewebsites.net")
        content.contentDescription = challenger.descriptionChallenge!
        FBSDKShareDialog.show(from: self, with: content, delegate: self)
        //        content.description = challenger.descriptionChallenge!
    }
    func willSetPickerDelegate(_ picker: SBPickerSelector) {
        picker.showPickerOver(self)
    }
    //MARK: Share touch
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
        print("didCompeleteshare \(results)")
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("didFailWithError \(error)")
    }
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("shareDidCancel")
    }
    //MARK: KeyboardDelegate
    override func keyboardWillChangeFrameWithNotification(_ notification: Foundation.Notification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        let animationDuration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardViewBeginFrame = view.convert(keyboardScreenBeginFrame, from: view.window)
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        if (showsKeyboard == true){
            bottomConstraint.constant =  5 - originDelta
            self.scrollToBottom()
    
        }else{
            bottomConstraint.constant = 5
        }
        
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: animationDuration, delay: 0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }){ (finish) -> Void in
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if velocity.y < -1.0 {
            self.view.endEditing(true)
        }
    }
}
