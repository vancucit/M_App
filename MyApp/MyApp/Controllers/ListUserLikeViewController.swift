//
//  ListUserLikeViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 5/26/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class ListUserLikeViewController: BaseViewController ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    var currentPageIndex = 0
    var hasLoadMore = true
    var isLoading = false
    
    var challengerID:String?
    var responseID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Like"

        tableView.tableFooterView = nil
        tableView.separatorColor = UIColor.clear
        delay(0.1, closure: { () -> () in
            self.resetAllData()
            self.retrieveData()
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        if(challengerID != nil){

            AppRestClient.sharedInstance.getVotersForChallenge(challengerID!, page: currentPageIndex, isLike: true, callback: { (usersLoad, error) -> () in
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
        }else if(responseID != nil){
            AppRestClient.sharedInstance.getVotersForResponse(responseID!, page: currentPageIndex, isLike: true, callback: { (usersLoad, error) -> () in
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
    //MARK - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userProfileVC = storyboard!.instantiateViewController(withIdentifier: "UserProfileViewControllerID") as! UserProfileViewController;
        
        userProfileVC.user =  users[indexPath.row]
        userProfileVC.idUser = userProfileVC.user?.idUser

        self.navigationController?.pushViewController(userProfileVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCellID", for: indexPath) as! UserTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count;
    }
}
