//
//  FollowViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
import SYPhotoBrowser

class ChallengeDetailViewController: BaseLoadMoreViewController{

    @IBOutlet weak var tableView: UITableView!
    
//    @IBOutlet weak var containResponseView: UIView!
    @IBOutlet weak var containChallengeView: UIView!
    
    var challengeView: ChallengeView!
    
    var responses = [Response]()
    
    
    var challengerID:String?
    var challenge:Challenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (challenge != nil){
            self.updateUI()
        }else{
            self.getChallengerDetail()
        }
        self.setTitleNavigationBar("Detail Challenger")
    }
    func getChallengerDetail(){
        self.showHudWithString("")
        AppRestClient.sharedInstance.getChallengerDetail(challengerID!) { (challenger, errorStr) in
            self.hideHudLoading()
            if let challngerForce = challenger {
                self.challenge = challngerForce
                self.updateUI()
            }else{
                self.showGeneralDialog()
            }
        }
    }
    
    //MARK - ui
    func updateUI(){
     
        if (challengeView == nil){
            if let aChallengeView = UIView.loadFromNibNamed("ChallengeView") as? ChallengeView{
                self.challengeView = aChallengeView
                
                self.challengeView.isDetailView = true
                self.challengeView.translatesAutoresizingMaskIntoConstraints = false
                
            }
        }
        self.challengeView.challenge = challenge
        self.containChallengeView.addSubview(self.challengeView)
        self.layoutSubviews()
        
        loadCommenst()
    }
    
    func layoutSubviews() {
        self.challengeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.containChallengeView).offset(0)
            make.left.equalTo(self.containChallengeView).offset(0)
            make.right.equalTo(self.containChallengeView).offset(0)
            make.bottom.equalTo(self.containChallengeView).offset(0)
        }
        
    }
    func getResponse(){
        
    }
   
    func loadCommenst(){
        if (self.isLoading || !isCanLoadMore){
            return
        }
        showHudLoadingInView(self.tableView)
        AppRestClient.sharedInstance.getResponsesForChallenge((challenge!.idChallenge)!, pageIndex: pageNumber) { (responseLoad, error) -> () in
            
            if((responseLoad) != nil){
                self.pageNumber += 1
//                for aMessage in responseLoad!{
//                    self.comments.insert(aMessage, at: 0)
//                }
                self.responses += responseLoad!
                self.isCanLoadMore = responseLoad?.count == AppRestClient.sharedInstance.Page_Count
                self.tableView.reloadData()
                self.scrollToBottom()
                

            }
            
            self.isLoading = false
            self.hideHudLoadingInView(self.tableView)
            self.tableView.reloadData()
//            if(self.isNeedShowComment){
//                self.txtViewContent.becomeFirstResponder()
//                self.isNeedShowComment = false
//            }
            
        }
    }
    func scrollToBottom(){
//        if(self.comments.count > 0){
//            self.tableView.scrollToRow(at: IndexPath(row: self.comments.count-1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
//        }
    }

}
extension ChallengeDetailViewController: UITableViewDataSource, UITableViewDelegate{
    //MARK - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.responses.count == 0 {
            //NoResponseCellID
            
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
            responseDetailVC.response = responses[indexPath.row]
            self.navigationController?.pushViewController(responseDetailVC, animated: true)
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.responses.count == 0 {
            //NoResponseCellID
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoResponseCellID", for: indexPath) 
            cell.textLabel?.text = "No reponse for this challenger"
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengerResponseViewCellTableViewCellID", for: indexPath) as! ChallengerResponseViewCellTableViewCell
            cell.response = self.responses[indexPath.row]
//            cell.isDet
            cell.responseView.delegate = self
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.responses.count > 0 ? responses.count : 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.responses.count > 0 ? 600 : 44)
    }
    
}

extension ChallengeDetailViewController: ResponseViewDelegate{
    func willGoToResponseOriginalChallenger(_ challenger: Challenge) {
    
        
    }
    func willGotoViewImageUrl(urlStr: String, caption:String) {
        let photoBrowser = SYPhotoBrowser.init(imageSourceArray: [urlStr], caption: caption)
        photoBrowser?.initialPageIndex = 0
        photoBrowser?.pageControlStyle = SYPhotoBrowserPageControlStyle.system
        self.present(photoBrowser!, animated: true, completion: nil)
    }
    func willReloadTableView(){
        
    }
    func willGoToResponseOriginal(_ challengerID:String){
        
    }
    func willGotoCommentResponse(_ response:Response){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
        
        responseDetailVC.response = response
        responseDetailVC.isNeedShowComment = true
        
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
    }
    func willGotoResponse(_ response:Response){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let responseDetailVC = storyboard.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
        responseDetailVC.response = response
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
        
    }
    func willGotoListUserLikeResponse(_ response:Response){
        
    }
    func willShareResponse(_ response:Response){
        
    }
    func willSetPickerDelegate(_ picker:SBPickerSelector){
        
    }

}
