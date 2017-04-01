//
//  FollowViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
enum TypeFollowStr:String{
    case RequestType = "request",FollwerType = "follower",FollowingType = "following"
}

class FollowViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var typeFollowSegment: UISegmentedControl!
    
    var users = [User]()
    
    var typeFollow:TypeFollowStr!
    
    var currentPageIndex = 0
    var hasLoadMore = true
    var isLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (typeFollow == .RequestType){
            typeFollowSegment.selectedSegmentIndex = 0
        }else if(typeFollow == .FollwerType){
            typeFollowSegment.selectedSegmentIndex = 1
        }else{
            typeFollowSegment.selectedSegmentIndex = 2
        }
//        self.showMenuButton()

        tableView.tableFooterView = nil
        tableView.separatorColor = UIColor.clear
        delay(0.1, closure: { () -> () in
            self.resetAllData()
            self.retrieveData()
        })
    }
    
    func resetAllData(){
        users.removeAll(keepingCapacity: false)
        
        currentPageIndex = 0
        hasLoadMore = true
        isLoading = false
        tableView.reloadData()
    }
    func retrieveData(){
        if(!hasLoadMore || isLoading){
            return
        }
        isLoading = true
        self.showHudLoadingInView(tableView)

        if (typeFollow == .RequestType){
            //
//            AppRestClient.sharedInstance.getPendingFollowers(currentPageIndex, keyword:"",  callback: { (usersLoad, error) -> () in
//                //
//                if (usersLoad != nil){
//                    self.currentPageIndex += 1
//                    self.users += usersLoad!
//                    self.hasLoadMore = usersLoad!.count == AppRestClient.sharedInstance.Page_Count
//                    self.tableView.reloadData()
//                }
//                self.hideHudLoadingInView(self.tableView)
//                self.isLoading = false
//            })
            self.hideHudLoadingInView(self.tableView)
            self.showDialogOnConstruction()
            
        }else{
            var following = true
            if(typeFollow == .FollwerType){
                following = false
            }
            
            AppRestClient.sharedInstance.getFollows(User.shareInstance.idUser, page:currentPageIndex, keyword:"", getFollowing:following,  callback: { (usersLoad, error) -> () in
                //
                if (usersLoad != nil){
                    self.currentPageIndex += 1
                    self.users += usersLoad!
                    self.hasLoadMore = usersLoad!.count == AppRestClient.sharedInstance.Page_Count
                    self.tableView.reloadData()
                }
                self.hideHudLoadingInView(self.tableView)
                self.isLoading = false
            })
        }
    }
    
    //MARK - IBAction
    @IBAction func segmentValueChanged(_ sender: AnyObject) {
    
        switch typeFollowSegment.selectedSegmentIndex{
        case 0:
            typeFollow = .RequestType
            break
        case 1:
            typeFollow = .FollwerType
            break
        case 2:
            typeFollow = .FollowingType
            break
        default:
            break
        }
        self.resetAllData()
        self.retrieveData()
    }
    
    
    //MARK - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userProfileVC = storyboard!.instantiateViewController(withIdentifier: "UserProfileViewControllerID") as! UserProfileViewController;
        
        userProfileVC.user = users[indexPath.row]
        userProfileVC.idUser = userProfileVC.user?.idUser
        self.navigationController?.pushViewController(userProfileVC, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCellID", for: indexPath) as! UserTableViewCell
        cell.user = users[indexPath.row]
        return cell
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count;
    }


}
