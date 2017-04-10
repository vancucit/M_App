//
//  LeftMenuViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LeftMenuViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource, FBSDKAppInviteDialogDelegate{
    /*!
     @abstract Sent to the delegate when the app invite encounters an error.
     @param appInviteDialog The FBSDKAppInviteDialog that completed.
     @param error The error.
     */
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
//        code
    }

 
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    var menuItems = [MenuItem]()
    var notificationItem:MenuItem!
   
    
    var isFirtTime = true
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge()
        self.navigationController?.navigationBar.isTranslucent = false
        let colorView = UIView()
        colorView.backgroundColor = UIColor.blue
        UITableViewCell.appearance().selectedBackgroundView = colorView

        tableView.tableFooterView = nil
        tableView.separatorColor = UIColor.clear
        
        //circle image view
        avatarImgView.layer.borderColor = UIColor.white.cgColor
        avatarImgView.layer.borderWidth = 1.0
        avatarImgView.layer.cornerRadius = avatarImgView.frame.size.width/2
        avatarImgView.clipsToBounds = true
        //add tap getsure
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(LeftMenuViewController.avatarTouched(_:)))
        avatarTapGesture.numberOfTapsRequired = 1
        avatarImgView.isUserInteractionEnabled = true
        avatarImgView.addGestureRecognizer(avatarTapGesture)
        
        updateLeftItem()
        
        self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.endEditing(true)
    }
    func updateLeftItem(){
        
        menuItems.append(MenuItem(title: "News", imageURL: "ic_news", notificationNum: ""))
        
        notificationItem = MenuItem(title: "Notifications", imageURL: "ic_notification", notificationNum: "0")
//        followwingItem = MenuItem(title: "Followings", imageURL: "ic_followings", notificationNum: "0")
//        followerItem = MenuItem(title: "Followers", imageURL: "ic_followers", notificationNum: "0")

        var followwingItem:MenuItem!
        var requestItem:MenuItem!
        
        followwingItem = MenuItem(title: "Following", imageURL: "ic_followings", notificationNum: "")
        menuItems.append(followwingItem)
        
        requestItem = MenuItem(title: "Request", imageURL: "ic_followings", notificationNum: "")
        menuItems.append(requestItem)
        
        menuItems.append(MenuItem(title: "Profile", imageURL: "ic_profile", notificationNum: ""))
        menuItems.append(MenuItem(title: "Scoreboard", imageURL: "ic_score_w", notificationNum: ""))
        if(AuthToken.sharedInstance.provideStr == "facebook"){
            menuItems.append(MenuItem(title: "Invite friends", imageURL: "ic_envelop_w", notificationNum: ""))
        }
        menuItems.append(MenuItem(title: "Settings", imageURL: "ic_settings", notificationNum: ""))
//        menuItems.append(notificationItem)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userUrlStr = User.shareInstance.getAvatarUrl() {
            let userUrl = URL(string: userUrlStr)
            avatarImgView.sd_setImage(with: userUrl, placeholderImage:  UIImage(named: "img_avatar_holder"))
        }
        
        lblUserName.text = User.shareInstance.nameUser
        
//        getNumNotifcation()
    }
    func getNumNotifcation(){
        if(isFirtTime){
            self.showHudLoadingInView(self.view)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        AppRestClient.sharedInstance.getBadgeCount { (badgeCount, error) -> () in
            if (badgeCount != nil){
                self.notificationItem.notificationNum = String(badgeCount!.getNotification())
//                self.followwingItem.notificationNum = String(badgeCount!.getFllowing())
//                self.followerItem.notificationNum = String(badgeCount!.getFollower())
                self.tableView.reloadData()
            }else{
                
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.hideHudLoadingInView(self.view)
            self.isFirtTime = false
        }

    }
    func avatarTouched(_ sender:AnyObject){
        print("will implement goto profile")
        let storyboard = UIStoryboard(name: "Users", bundle: nil)
        let myProfileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewControllerID") as! MyProfileViewController;
        let navProfileVC = UINavigationController(rootViewController: myProfileVC)
        self.present(navProfileVC, animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - UITableViewDelegate, UITableViewDatasource

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRow at index \(indexPath.row)")
        switch indexPath.row{
        case 0:
            let newVC = storyboard!.instantiateViewController(withIdentifier: "NewsViewControllerID") as! NewsViewController
            newVC.currentNewFeedType = NewsType.News
            let naVC = UINavigationController(rootViewController: newVC)
            self.mm_drawerController.setCenterView(naVC, withCloseAnimation: true, completion: nil)
            break
       
        case 1:
            let newVC = storyboard!.instantiateViewController(withIdentifier: "NewsViewControllerID") as! NewsViewController
            newVC.currentNewFeedType = NewsType.Following
            let naVC = UINavigationController(rootViewController: newVC)
            self.mm_drawerController.setCenterView(naVC, withCloseAnimation: true, completion: nil)
            break
        case 2:
            let newVC = storyboard!.instantiateViewController(withIdentifier: "NewsViewControllerID") as! NewsViewController
            newVC.currentNewFeedType = NewsType.NewChallenger
            let naVC = UINavigationController(rootViewController: newVC)
            self.mm_drawerController.setCenterView(naVC, withCloseAnimation: true, completion: nil)
            break
        case 3:
            let storyboard = UIStoryboard(name: "Users", bundle: nil)
            let myProfileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileViewControllerID") as! MyProfileViewController;
            myProfileVC.isShowMenuHome = true
            let naVC = UINavigationController(rootViewController: myProfileVC)
            self.mm_drawerController.setCenterView(naVC, withCloseAnimation: true, completion: nil)
            break
        case 4:
            let scoreBoardVC = storyboard!.instantiateViewController(withIdentifier: "ScoreboardViewControllerID") as! ScoreboardViewController;
            let naVC = UINavigationController(rootViewController: scoreBoardVC)
            self.mm_drawerController.setCenterView(naVC, withCloseAnimation: true, completion: nil)
            break
        case 5:
            if(AuthToken.sharedInstance.provideStr != "facebook"){
                let settingsVC = storyboard!.instantiateViewController(withIdentifier: "SettingViewControllerID") as! SettingViewController;
                let naVC = UINavigationController(rootViewController: settingsVC)
                self.mm_drawerController.setCenterView(naVC, withCloseAnimation: true, completion: nil)
                break
            }else{
                //show invite friend 
                self.inviteApp()
            }
        case 6:
            if(AuthToken.sharedInstance.provideStr == "facebook"){
                let settingsVC = storyboard!.instantiateViewController(withIdentifier: "SettingViewControllerID") as! SettingViewController;
                let naVC = UINavigationController(rootViewController: settingsVC)
                self.mm_drawerController.setCenterView(naVC, withCloseAnimation: true, completion: nil)
                break
            }
        case 7:
            let notificationVC = storyboard!.instantiateViewController(withIdentifier: "NotificationViewControllerID") as! NotificationViewController
            let naVC = UINavigationController(rootViewController: notificationVC)
            self.mm_drawerController.setCenterView(naVC, withCloseAnimation: true, completion: nil)
            
            break
            
        default:
            self.mm_drawerController.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        }

    }
    func inviteApp(){
        let content = FBSDKAppInviteContent()
        content.appLinkURL = URL(string: "https://fb.me/1183838701642243")
        content.appInvitePreviewImageURL = URL(string: "http://s21.postimg.org/bxp08ldtv/icon180.png")
        
        FBSDKAppInviteDialog.show(from: self, with: content, delegate: self);
//        FBSDKAppInviteDialog.showWithContent(content, delegate: self)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCellID", for: indexPath) as! LeftMenuTableViewCell
        cell.menuItem = menuItems[indexPath.row]
        cell.setNeedsDisplay()
        return cell
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count;
    }
    //MARK: app invite dialog callback
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable: Any]!) {
        print("didCompleteWithResults")
    }
   
    
    //MARK: Test login
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! NSDictionary
                    print(result ?? "--")
                    print(dict)
                    NSLog((dict.object(forKey: "picture") as AnyObject).object(forKey: "data")?.object(forKey: "url") as! String)
                }
            })
        }
    }

}
