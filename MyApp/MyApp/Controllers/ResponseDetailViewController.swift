//
//  ResponseDetailViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/30/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class ResponseDetailViewController: BaseKeyboardViewController  {
    
    
    @IBOutlet weak var txtViewContent: UIPlaceHolderTextView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var bottomConstrant: NSLayoutConstraint!
    
    
    var headerReponseView:ResponseView!
    
    var comments = [ResponseComment]()
    var currentPageIndex = 0
    var hasLoadMore = true
    var isLoading = false
    
    var isNeedShowComment = false
    var response:Response!{
        didSet{
            
        }
    }
    var newFeed:NewFeed?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160
        //set head

        headerReponseView = UIView.loadFromNibNamed("ResponseView") as! ResponseView
        headerReponseView.response = response
        headerReponseView.delegate = self
        headerReponseView.isDetailView = true
        //get height from response
        var heighResponse:CGFloat = 540
        print("height - : \(headerReponseView.lblTextRepsone.sizeOfMultiLineLabel().height)")
        heighResponse = heighResponse + headerReponseView.lblTextRepsone.sizeOfMultiLineLabel().height
        headerReponseView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: heighResponse)
        tableView.tableHeaderView = headerReponseView
        

        txtViewContent.layer.borderColor = UIColor.gray.cgColor
        txtViewContent.layer.borderWidth = 1.0
        txtViewContent.layer.cornerRadius = 2.0
        txtViewContent.clipsToBounds = true
        self.setTitleNavigationBar("Detail Response")

    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetAllData()
        retrieveData()
    }
    func retrieveData(){
        if(!hasLoadMore || isLoading){
            return
        }
        isLoading = true
        
        self.showHudLoadingInView(tableView)
        AppRestClient.sharedInstance.getCommentsForResponse(response.idResponse, pageIndex: currentPageIndex) { (commentLoads, error) -> () in
            if commentLoads != nil {
                self.currentPageIndex += 1
                self.comments += commentLoads!
                self.hasLoadMore = commentLoads?.count == AppRestClient.sharedInstance.Page_Count
                self.tableView.reloadData()
                if(self.isNeedShowComment){
                    self.txtViewContent.becomeFirstResponder()
                    self.isNeedShowComment = false
                }
                self.scrollToBottom()

            }
            self.hideHudLoadingInView(self.tableView)
            self.isLoading = false
        }
        
    }
  
    func resetAllData(){
        comments.removeAll(keepingCapacity: false)

        currentPageIndex = 0
        hasLoadMore = true
        isLoading = false
        tableView.reloadData()
    }
   
    
    
    //MARK: IBaction
    @IBAction func sendTouched(_ sender: AnyObject) {
        if (txtViewContent.text.characters.count == 0){
            return
        }
        
        self.showHudLoadingInView(self.btnSend)
        AppRestClient.sharedInstance.commentResponse(self.response.idResponse , comment: txtViewContent.text) { (success, error) -> () in
            if (success){
                self.resetAllData()
                self.retrieveData()
                self.txtViewContent.text = ""
                //update comment count
                self.response.commentCount += 1
                self.headerReponseView.response = self.response

            }else{
                if let errorStr = error {
                    self.showDialog("Send response failured.", contentStr: errorStr)
                }else{
                    self.showDialog("Send response failured.", contentStr: "")
                }
                
            }
            self.hideHudLoadingInView(self.btnSend)
        }
    }
   
    
    func willSetPickerDelegate(_ picker:SBPickerSelector){
        picker.showPickerOver(self)
    }
   
    //MARK: Keyboard
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
            bottomConstrant.constant =  5 - originDelta
            self.scrollToBottom()
            
        }else{
            bottomConstrant.constant = 5
        }
        
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: animationDuration, delay: 0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }){ (finish) -> Void in
        }
    }
    func scrollToBottom(){
        DispatchQueue.main.async(execute: { () -> Void in
            if(self.comments.count > 0){
                self.tableView.scrollToRow(at: IndexPath(row: self.comments.count-1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
            }
        })
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y < -1.0 {
            self.view.endEditing(true)
        }
    }

}
extension ResponseDetailViewController: UITableViewDataSource, UITableViewDelegate{
    //MARK - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        tableView.deselectRow(at: indexPath, animated: false)
    }
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeDetailTableViewCellID", for: indexPath) as! ChallengeDetailTableViewCell
        var comment = comments[indexPath.row]
        cell.lblContentMsg.text = comment.commentContent
        
        print("content msg \(comment.commentContent)")
        cell.lblUserName.text = comment.user?.nameUser
        if comment.postedOn != nil {
            cell.lblTimeAgo.text = getDisplayDateTime(comment.postedOn!)
        }else{
            print("cellForRow crash")
            cell.lblTimeAgo.text = ""
        }
        
        if let userAvatar = comment.user?.getThumnailAvatar(){
            let userUrl = URL(string: userAvatar)
            cell.imgAvatarUser.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
        }
        
        
        return cell
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count;
    }
}
extension ResponseDetailViewController: ResponseViewDelegate{
     func willGoToResponseOriginalChallenger(_ challenger: Challenge) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ChallengeDetailViewControllerID") as! ChallengeDetailViewController
        responseDetailVC.challenge = challenger
        
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
    }

    //MARK: ResponseViewDelegate
    func willGoToResponseOriginal(_ challenger: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ChallengeDetailViewControllerID") as! ChallengeDetailViewController
        responseDetailVC.challengerID = challenger
        self.navigationController?.pushViewController(responseDetailVC, animated: true)

     
        
    }
    func willReloadTableView(){
        //
    }
    func willGotoCommentResponse(_ response:Response){
        //
    }
    func willGotoResponse(_ response:Response){
        //
    }
    func willGotoListUserLikeResponse(_ response: Response) {
        let listUserLikeVC = storyboard!.instantiateViewController(withIdentifier: "ListUserLikeViewControllerID") as! ListUserLikeViewController
        listUserLikeVC.responseID = response.idResponse
        self.navigationController?.pushViewController(listUserLikeVC, animated: true)
        
    }
    func willShareResponse(_ response:Response){
        let content = FBSDKShareLinkContent()
        content.contentTitle =  "MApp is a social gameing app"
        content.contentURL = URL(string: "http://mapp1.azurewebsites.net")
        content.contentDescription = response.comment
        FBSDKShareDialog.show(from: self, with: content, delegate: self)
        
    }
}
extension ResponseDetailViewController:FBSDKSharingDelegate{
    //MARK: FBSDKShareDialog delegate
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
        print("didCompeleteshare \(results)")
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("didFailWithError \(error)")
    }
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("shareDidCancel")
    }

}
