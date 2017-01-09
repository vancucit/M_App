//
//  ScoreboardViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class ScoreboardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentScoreBoard: UISegmentedControl!
    
    var userTop50s = [User]()
    var userFollowings = [User]()
    
    var currentFollowingPageIndex = 0
    var hasMoreFollowing = true
    var isFollowingLoading = false
    var top50Loaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleNavigationBar("Scoreboard")
      
        self.showMenuButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateUI()
    }

    
   
    @IBAction func segmentScoreboardChanged(_ sender: AnyObject) {
        self.updateUI()
    }
    func updateUI(){
        if(segmentScoreBoard.selectedSegmentIndex == 0){
            retrieveTop50()
        }else{
            resetFollowingDisplay()
            retrieveFollowing()
        }
    }
    func retrieveTop50(){
        if(!top50Loaded){
            self.showHudWithString("")
            AppRestClient.sharedInstance.getTop50Users({ (userLoads, error) -> () in
                if((userLoads) != nil){
                    self.userTop50s = userLoads!
                    self.tableView.reloadData()
                    self.top50Loaded = true
                }
                self.hideHudLoading()
            })
        }else{
            self.tableView.reloadData()
        }
    }
    func retrieveFollowing(){
        if(!hasMoreFollowing || isFollowingLoading){
            return
        }
        isFollowingLoading = true

        self.showHudWithString("")
        AppRestClient.sharedInstance.getFollows(AuthToken.sharedInstance.currentUser!.idUser, page: currentFollowingPageIndex, keyword: "", getFollowing: true) { (usersLoad, error) -> () in
            if((usersLoad) != nil){
                self.currentFollowingPageIndex += 1
                self.userFollowings += usersLoad!
                self.hasMoreFollowing = usersLoad?.count == AppRestClient.sharedInstance.Page_Count
                self.tableView.reloadData()
            }
            self.isFollowingLoading = false
            self.hideHudLoading()
        }
    }
    //following
    func resetFollowingDisplay(){
        currentFollowingPageIndex = 0
        hasMoreFollowing = true
        userFollowings.removeAll(keepingCapacity: false)
        tableView.reloadData()

    }
    
    //MARK - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        //
        let userProfileVC = storyboard!.instantiateViewController(withIdentifier: "UserProfileViewControllerID") as! UserProfileViewController;
        
        if(self.segmentScoreBoard.selectedSegmentIndex == 0){
            userProfileVC.user = userTop50s[indexPath.row]
            userProfileVC.idUser = userProfileVC.user?.idUser
        }else{
            userProfileVC.user =  userFollowings[indexPath.row]
            userProfileVC.idUser = userProfileVC.user?.idUser
        }
        self.navigationController?.pushViewController(userProfileVC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserScoreboardTableViewCellID", for: indexPath) as! UserScoreboardTableViewCell
        if(self.segmentScoreBoard.selectedSegmentIndex == 0){
            cell.user = userTop50s[indexPath.row]
        }else{
            cell.user =  userFollowings[indexPath.row]
        }

        return cell
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.segmentScoreBoard.selectedSegmentIndex == 0){
            return userTop50s.count
        }else{
            return userFollowings.count
        }
    }

}
