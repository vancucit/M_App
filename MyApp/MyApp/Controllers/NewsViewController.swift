//
//  NewsViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu


enum NewsType:String{
    case NewChallenger = "Request"
    case News = "News"
    case Following = "Following"
    case NoneType = "None"
}
class NewsViewController: BaseKeyboardViewController , NewsTableViewCellDelegate, SendReplyMessageControllerDelegate, ChallengeViewDelegate, FBSDKSharingDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewGraydientLayer: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var menuView:BTNavigationDropdownMenu!
    
    var currentNewFeedType:NewsType!{
        didSet{
            switch currentNewFeedType! {
            case NewsType.News:
                self.setTitleNavigationBar("News")
                break
            case NewsType.Following:
                self.setTitleNavigationBar("Following")
                break
            case NewsType.NewChallenger:
                self.setTitleNavigationBar("Request")
                break
            default:
                break
            }
        }
    }
    
    var newFeeds = [NewFeed]()
    
    var hasMoreFeed = true
    var isLoading = false

    var currentNewsPageIndex = 0
    
    var btnTitle:UIButton!
    var refreshControl:UIRefreshControl!
    
    var isCompletedRequest:Bool?
    var userID:String?
    var responses = [Response]()
    var isFirstTime = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 500

//        currentNewFeedType = .NoneType
        if (isCompletedRequest != nil &&  isCompletedRequest!) {
            self.setTitleNavigationBar("Completed requests")
            self.getResponse()
            searchBar.isHidden = true
        }else{
            //add pull to refresh
            
            refreshControl = UIRefreshControl()
            self.refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("refresh_pull_down", comment: "refresh_pull_down"),attributes:[NSForegroundColorAttributeName:UIColor.gray,NSFontAttributeName:UIFont.systemFont(ofSize: 16)])
            
            refreshControl.addTarget(self, action: #selector(NewsViewController.refreshDataSource(_:)), for: UIControlEvents.valueChanged)
            
            self.tableView.addSubview(refreshControl)
            self.showMenuButton()
            self.setRightNavigationWithImage("ic_create_challenge", action: #selector(NewsViewController.createNewChallengerTouched(_:)))
            
            
            delay(0.3, closure: { () -> () in
//                self.changNavTitleToString(.News)
                self.resetAllData()
                self.updateUI()
            })
            
            let items = ["News", "Following", "Request"]
            self.menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "News", items: items as [AnyObject])
//            self.navigationItem.titleView = menuView
            
            menuView.arrowTintColor = UIColor.black
            menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
                print("Did select item at index: \(indexPath)")
                switch indexPath {
                case 0:
                    self?.changNavTitleToString(NewsType.News)
                    break
                case 1:
                    self?.changNavTitleToString(NewsType.Following)
                    break
                case 2:
                    self?.changNavTitleToString(NewsType.NewChallenger)
                    
                    break
                default:
                    break
                }
            }
            

        }
        
//        fatalError()

        
    }
    func refreshDataSource(_ sender:AnyObject){
        self.resetAllData()
        self.updateUI()
    }
    func resetAllData(){
        newFeeds.removeAll(keepingCapacity: false)
        currentNewsPageIndex = 0
        hasMoreFeed = true
        isLoading = false
        
        tableView.reloadData()
    }
    func createNewChallengerTouched(_ sender:AnyObject?){
        self.hideTopOption()
        let storyboard = UIStoryboard(name: "SendMessage", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "SendMessageViewControllerID") as! SendMessageViewController;
        self.navigationController?.pushViewController(newVC, animated: true)

    }
    func changNavTitleToString(_ newType:NewsType){
        self.view.endEditing(true)
//        var isNeedUpdateUI = true
//        if(currentNewFeedType == newType){
//            isNeedUpdateUI = false
//        }
        currentNewFeedType = newType
        self.resetAllData()
        self.updateUI()
  
    }
  
    func hideTopOption(){
        self.menuView.hide()
    }
    func getResponse(){
        if(isLoading){
            return
        }
        isLoading = true
        self.showHudWithString("")
        AppRestClient.sharedInstance.getResponse(currentNewsPageIndex, userId: userID!) { (responsesLoad, error) -> () in
            if(responsesLoad != nil){
                self.responses +=  responsesLoad!
                self.currentNewsPageIndex += 1
                self.hasMoreFeed = responsesLoad!.count == AppRestClient.sharedInstance.Page_Count
                self.tableView.reloadData()
            }else{
                self.showGeneralDialog()
            }
            self.hideHudLoading()
        }
    }
    func updateUI(){
   
    
        if(isLoading){
            return
        }
        print("updateUI")
        isLoading = true
        self.showHudWithString("")
        AppRestClient.sharedInstance.getNewFeedTest(currentNewsPageIndex, newFeedType:currentNewFeedType, keyword: "", callback: { (challengeLoads, error) -> () in
            if(challengeLoads != nil){
                
                self.newFeeds += challengeLoads!
                self.hasMoreFeed = challengeLoads?.count == AppRestClient.sharedInstance.Page_Count
                self.tableView.reloadData()
            }else{
                self.showGeneralDialog()
            }
            self.isLoading = false
            self.hideHudLoading()
            self.refreshControl.endRefreshing()
            self.hideHudLoading()
        })
        /*
        if(isLoading){
            return
        }
        isLoading = true
        self.showHudWithString("")
        AppRestClient.sharedInstance.getNewFeed(currentNewsPageIndex, newFeedType:currentNewFeedType, keyword: "", callback: { (challengeLoads, error) -> () in
            if(challengeLoads != nil){
                
                self.newFeeds += challengeLoads!
                self.hasMoreFeed = challengeLoads?.count == AppRestClient.sharedInstance.Page_Count
                self.tableView.reloadData()
            }else{
                self.showGeneralDialog()
            }
            self.isLoading = false
            self.hideHudLoading()
            self.refreshControl.endRefreshing()
        })
 */

    }
     func isChallengerMode() -> Bool{
        return currentNewFeedType == NewsType.NewChallenger ? true : false
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == tableView){
            self.hideTopOption()
        }
    }
    @IBAction func hiddenCategoryView(_ sender: AnyObject) {
        self.hideTopOption()
    }
    
    
    func calculateHeightForConfiguredSizingCell(_ sizingCell:ResponseTableViewCell) -> CGFloat{
        return sizingCell.responseView.heightOfResponseView() + sizingCell.challengeView.heightContraintChallengerView() + 60
    }
    func willOpenProfileUser(_ idString:String){
        let storyboard = UIStoryboard(name: "Users", bundle: nil)

        let userProfileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewControllerID") as! UserProfileViewController;
        userProfileVC.idUser = idString
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    func willRejectChallenger(_ idChallenger:String){
        self.showHudWithString("")
        AppRestClient.sharedInstance.rejectChallenger(idChallenger, callback: { (success, error) -> () in
            self.hideHudLoading()

            if(success){
                self.resetAllData()
                self.updateUI()
            }else{
                self.showGeneralDialog()
            }
        })
    }
    func willReplyChallenge(_ idChallenger: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let replyVC = storyboard.instantiateViewController(withIdentifier: "SendReplyMessageViewControllerID") as! SendReplyMessageViewController
        replyVC.challengerID = idChallenger
        replyVC.delegate = self
        self.navigationController?.pushViewController(replyVC, animated: true)
    }
    
    //MARK: SendReplyDelegate
    func willReloadDataSource() {
//        self.resetAllData()
//        self.updateUI()
    }
    
    //MARK: ResponseViewDelegate
    func willReloadTableView(){
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
        //MARK: ChallengerViewDelegate
   
    func willLikeResponse(_ idResponse:String){
        
    }
    func willGoListUserLike(_ challenger: Challenge) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let listUserLikeVC = storyboard.instantiateViewController(withIdentifier: "ListUserLikeViewControllerID") as! ListUserLikeViewController
        listUserLikeVC.challengerID = challenger.idChallenge
        self.navigationController?.pushViewController(listUserLikeVC, animated: true)
    }
    func willCommentResponse(_ challenger:Challenge){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailChallenger = storyboard.instantiateViewController(withIdentifier: "NewFeedDetailViewControllerID") as! NewFeedDetailViewController
        detailChallenger.challenger = challenger
        detailChallenger.isNeedShowComment = true
    self.navigationController?.pushViewController(detailChallenger, animated: true)
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
    
    //MARK:  keyboard
    override func keyboardWillChangeFrameWithNotification(_ notification: Foundation.Notification, showsKeyboard: Bool) {
        if(showsKeyboard){
            let userInfo = notification.userInfo!
            if let rectKB = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsetsMake(0, 0, rectKB.height, 0)
                tableView.contentInset = contentInsets
                tableView.scrollIndicatorInsets = contentInsets
                
            }
        }else{
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }
    
    
}
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: UITableViewDelegate Datasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideTopOption()
        tableView.deselectRow(at: indexPath, animated: false)
        if (isCompletedRequest != nil){
            let response = responses[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let detailChallenger = storyboard.instantiateViewController(withIdentifier: "NewFeedDetailViewControllerID") as! NewFeedDetailViewController
            detailChallenger.newFeed = NewFeed(response: response)
            self.navigationController?.pushViewController(detailChallenger, animated: true)
        }else{
            let newFeed = newFeeds[indexPath.row]
            
            /*
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             
             let detailChallenger = storyboard.instantiateViewController(withIdentifier: "NewFeedDetailViewControllerID") as! NewFeedDetailViewController
             detailChallenger.newFeed = newFeed
             
             self.navigationController?.pushViewController(detailChallenger, animated: true)
             */
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            if isChallengerMode() {

                let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ChallengeDetailViewControllerID") as! ChallengeDetailViewController
                responseDetailVC.challenge = newFeed.getItem() as? Challenge
                self.navigationController?.pushViewController(responseDetailVC, animated: true)
            }else{
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
                responseDetailVC.response = newFeed.getItem() as! Response
                self.navigationController?.pushViewController(responseDetailVC, animated: true)
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.endUpdates()
        if(isChallengerMode()){
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsID") as! NewsTableViewCell
            cell.delegate = self
            let newFeed = newFeeds[indexPath.row]
            cell.challenge = newFeed.getItem() as? Challenge
            return cell
        }else{
            /*
             let cell = tableView.dequeueReusableCell(withIdentifier: "NewsID") as! NewsTableViewCell
             cell.delegate = self
             let newFeed = newFeeds[indexPath.row]
             cell.challenge = newFeed.getItem() as? Challenge
             return cell
             */
            //TODO need change later
            let cellReponse = tableView.dequeueReusableCell(withIdentifier: "ResponseTableViewCellID") as! ResponseTableViewCell
            self.configTableViewCellAtIndex(cellReponse, indexPath: indexPath)
            return cellReponse
        }
        
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isCompletedRequest != nil && isCompletedRequest!){
            return self.responses.count
        }
        return newFeeds.count
    }
}
extension NewsViewController: ResponseViewDelegate{
     func willGoToResponseOriginalChallenger(_ challenger: Challenge) {
        
    }

    func willGoToResponseOriginal(_ challenger:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ChallengeDetailViewControllerID") as! ChallengeDetailViewController
        responseDetailVC.challengerID = challenger
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
    }
    func willGotoCommentResponse(_ response:Response){
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
        responseDetailVC.response = response
        responseDetailVC.isNeedShowComment = true
        
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
 */
        self.willReplyChallenge("11")
    }
    func willGotoResponse(_ response: Response) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
        var newFeed:NewFeed?
        for aNewFeed in newFeeds {
            if let aResponse = aNewFeed.getItem() as? Response {
                if aResponse == response{
                    newFeed = aNewFeed
                    break
                }
            }
        }
        responseDetailVC.newFeed = newFeed
        responseDetailVC.response = response
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
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
extension NewsViewController{
    //MARK:   NewsTableViewCellDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(currentNewFeedType == NewsType.NewChallenger){
            //            return 470
            return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
        
        //        return heightForBasicCellAtIndexPath(indexPath)
    }
    
    func heightForChallengerCellAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        struct Static {
            static var sizingCell: NewsTableViewCell?
        }
        
        if Static.sizingCell == nil {
            Static.sizingCell =  (tableView.dequeueReusableCell(withIdentifier: "NewsID") as! NewsTableViewCell)
            
        }
        self.configTableViewCellChallengerAtIndex(Static.sizingCell!, indexPath: indexPath)
        
        return self.calculateHeightForConfiguredSizingCellChallenger(Static.sizingCell!)
    }
    
    func configTableViewCellChallengerAtIndex(_ cell:NewsTableViewCell, indexPath:IndexPath){
        
        
    }
    
    func calculateHeightForConfiguredSizingCellChallenger(_ sizingCell:NewsTableViewCell) -> CGFloat{
        if isChallengerMode() {
            return 400
        }
        return 700
        
        //        return sizingCell.responseView.heightOfResponseView() + sizingCell.challengeView.heightContraintChallengerView() + 60
        
    }
    
    func heightForBasicCellAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        struct Static {
            static var sizingCell: ResponseTableViewCell?
        }
        
        if Static.sizingCell == nil {
            Static.sizingCell = (tableView.dequeueReusableCell(withIdentifier: "ResponseTableViewCellID") as! ResponseTableViewCell)
        }
        self.configTableViewCellAtIndex(Static.sizingCell!, indexPath: indexPath)
        
        return self.calculateHeightForConfiguredSizingCell(Static.sizingCell!)
    }
    func configTableViewCellAtIndex(_ cell:ResponseTableViewCell, indexPath:IndexPath){
        
        cell.addCommonUI()
        //        cell.responseView.originalBtn.isHidden = true
        if isCompletedRequest != nil  && isCompletedRequest!{
            let responsOjb = responses[indexPath.row]
            
            //            cell.challengeView.challenge = responsOjb.challenger
            cell.responseView.response = responsOjb
        }else{
            //
            //            if indexPath.row >= newFeeds.count {
            //                print("Crash here")
            //            }
            //            print("indexPath1 : \(indexPath.row) --- index new feedcoutn \(newFeeds.count) ")
            let newFeed = newFeeds[indexPath.row]
            //
            let responsOjb = newFeed.getItem() as! Response
            //            cell.challengeView.challenge = responsOjb.challenger
            //            cell.responseView.response = responsOjb
            
            //            var responsOjb = responses[indexPath.row]
            
            //            cell.challengeView.challenge = responsOjb.challenger
            cell.responseView.response = responsOjb
            cell.challengeView.challenge = responsOjb.challenger
            cell.challengeView.isHeaderView = true
            
        }
        //        cell.challengeView.bottomLikeCommentShare.isHidden = false
        //        cell.challengeView.delegate = self
        cell.responseView.delegate = self
        cell.responseView.isDetailView = false
        
        cell.updateUI()
    }
}
extension NewsViewController: SendMessageDelegate{
    func didSendNewMessage() {
        self.resetAllData()
        self.updateUI()
    }
}
