//
//  FollowViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class CompletedResponseViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource, ResponseViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var userID:String!
    var responses = [Response]()
    
    var currentPageIndex = 0
    var hasMore = true
    var isLoading = false
    
    var cellCache = [CompletedTableViewCell?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleNavigationBar("Completed requests")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetData()
        retrieveData()
    }
    func resetData(){
        hasMore = true
        currentPageIndex = 0
        isLoading = false
    }
    func retrieveData(){
        if(isLoading){
            return
        }
        self.showHudWithString("")
        AppRestClient.sharedInstance.getResponse(currentPageIndex, userId: userID) { (responsesLoad, error) -> () in
            if(responsesLoad != nil){
                self.responses += responsesLoad!
                self.currentPageIndex += 1
                self.hasMore = responsesLoad!.count == AppRestClient.sharedInstance.Page_Count
                self.tableView.reloadData()
            }else{
                self.showGeneralDialog()
            }
            self.hideHudLoading()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let responseDetailVC = storyboard!.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
        responseDetailVC.response = responses[indexPath.row]
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTableViewCellID", for: indexPath) as! CompletedTableViewCell
        
        self.configTableViewCellAtIndex(cell, indexPath: indexPath)

        if (cellCache.count <= indexPath.row){
            cellCache.insert(cell, at: indexPath.row)
        }
        return cell
        //
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return self.heightForBasicCellAtIndexPath(indexPath)
    }
    func heightForBasicCellAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        if(indexPath.row < cellCache.count){
            let cell = cellCache[indexPath.row]
            
            if(cell != nil){
                if (cell!.containResponseView.imgResponse.image != nil){
                    return cell!.containResponseView.heightContainResponseView.constant
                }
            }
        }
        return 500
    }
    func configTableViewCellAtIndex(_ cell:CompletedTableViewCell, indexPath:IndexPath){
        cell.updateUI()
        cell.containResponseView.response = responses[indexPath.row]
        cell.containResponseView.delegate = self
    }
 
    
//    func calculateHeightForConfiguredSizingCell(sizingCell:CompletedTableViewCell) -> CGFloat{
//    
//        return size.height + 1.0
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (isLoading == false && scrollView.isDragging == false && scrollView.isDecelerating == false){
            if(hasMore){
                if(scrollView.contentSize.height - scrollView.frame.size.height <= scrollView.contentOffset.y){
                    self.retrieveData()
                }
            }
        }
    }
    //MARK: ResponseViewDelegate
    func willReloadTableView(){
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
   
    func willGoToResponseOriginal(_ challenger:Challenge){
        let responseDetailVC = storyboard!.instantiateViewController(withIdentifier: "ChallengeDetailViewControllerID") as! ChallengeDetailViewController
        responseDetailVC.challenge = challenger
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
    }
    func willGotoResponse(_ response: Response) {
        let responseDetailVC = storyboard!.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
        responseDetailVC.response = response
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
    }
    func willGotoCommentResponse(_ response: Response) {
        let responseDetailVC = storyboard!.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
        responseDetailVC.response = response
        responseDetailVC.isNeedShowComment = true
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
    }
    func willGotoListUserLikeResponse(_ response: Response) {
        //
    }
    func willShareResponse(_ response: Response) {
        //
    }
    func willSetPickerDelegate(_ picker:SBPickerSelector){
        picker.showPickerOver(self)
    }
}
