//
//  UserProfileViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class UserProfileViewController: BaseViewController {
    
    @IBOutlet weak var replyImgScrollView: UIScrollView!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var segmentUser: UISegmentedControl!
    
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var imgFollow: UIImageView!
    
    @IBOutlet weak var btnChallenge: UIButton!
    @IBOutlet weak var imgChallenge: UIImageView!
    
    @IBOutlet weak var btnBio: UIButton!
    @IBOutlet weak var imgBio: UIImageView!
    
    @IBOutlet weak var imgScore: UIImageView!
    @IBOutlet weak var btnScore: UIButton!
    
    @IBOutlet weak var imgRank: UIImageView!
    @IBOutlet weak var btnRank: UIButton!

    
    @IBOutlet weak var btnListCheck: UIButton!
    @IBOutlet weak var imgListCheck: UIImageView!
    
    @IBOutlet weak var verticalFollowBtnSegment: NSLayoutConstraint!
    
    @IBOutlet weak var verticalBtnBioViewLine: NSLayoutConstraint!
    
    @IBOutlet weak var verticalChallengerVsFollow: NSLayoutConstraint!
    var idUser:String?
    var user:User?
    
    var responses = [Response]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.user != nil){
            self.updateUIUser()
        }
        self.delay(0.2, closure: { () -> () in
            if(self.idUser != nil){
                self.showHudWithString("")
                AppRestClient.sharedInstance.getUser(self.idUser!, callback: { (userLoad, error) -> () in
                    if(userLoad != nil){
                        self.user = userLoad
                        self.updateUIUser()
                        self.getResponseImage(0)
                    }else{
                        self.showGeneralDialog()
                    }
                    self.hideHudLoading()
                })
            }
        })

    }
    func updateUIUser(){
        
        
        txtUserName.text = user!.nameUser
        var userUrl = URL(string: user!.avatar)
        imgAvatar.sd_setImage(with: userUrl, placeholderImage:  UIImage(named: "img_avatar_holder"))
        
        updateTitleFollow()
        
        if(AuthToken.isCurrentUser(user!.idUser)){
            //hidden follow, challenger
            verticalFollowBtnSegment.constant = -50
            imgFollow.isHidden = true
            btnFollow.isHidden = true
            
            imgChallenge.isHidden = true
            btnChallenge.isHidden = true
            self.setTitleNavigationBar("Your profile")
        }else{
            self.setTitleNavigationBar(user!.nameUser + "'s profile")
            updateFollowState()
        }
        if(user!.isPublic){
            if(user!.bio != nil && user!.bio!.characters.count > 0){
                btnBio.setTitle(user!.bio!, for: UIControlState())
            }else{
                imgBio.isHidden = true
                btnBio.isHidden = true
                verticalBtnBioViewLine.constant = -30
            }
            
            btnScore.setTitle(String(user!.point), for: UIControlState())
            btnRank.setTitle(String(user!.currentRank), for: UIControlState())
            btnListCheck.setTitle(String(user!.completedChallenges), for: UIControlState())
            
        }else{
            imgScore.isHidden = true
            btnScore.isHidden = true
            imgRank.isHidden = true
            btnRank.isHidden = true
            imgListCheck.isHidden = true
            btnListCheck.isHidden = true
            imgBio.isHidden = true
            btnBio.isHidden = true
        }
    }
    func imageTouched(_ sender:AnyObject){
     
        let responseDetailVC = storyboard!.instantiateViewController(withIdentifier: "ResponseDetailViewControllerID") as! ResponseDetailViewController
        let tapGesture = sender as! UIGestureRecognizer
        
        responseDetailVC.response = responses[tapGesture.view!.tag - 11]
        self.navigationController?.pushViewController(responseDetailVC, animated: true)
        
    }
    func updateTitleFollow(){
        var followingStr = " following"
        if(user!.followingCount > 1){
            followingStr = " followings"
        }
        var followerStr = " follower"
        if(user!.followerCount > 1){
            followerStr = " followers"
        }
        segmentUser.setTitle(String(user!.followerCount) + followerStr, forSegmentAt: 0)
        segmentUser.setTitle(String(user!.followingCount) + followingStr, forSegmentAt: 1)

    }
    func updateFollowState(){
        if(user!.isFollowing){
            imgFollow.image = UIImage(named: "ic_follow")
            btnFollow.setTitle("UnFollow", for: UIControlState())
            imgChallenge.isHidden = false
            btnChallenge.isHidden = false
            self.verticalChallengerVsFollow.constant = 10
        }else{
            imgFollow.image = UIImage(named: "ic_not_follow")
            btnFollow.setTitle("Follow", for: UIControlState())
            imgChallenge.isHidden = true
            btnChallenge.isHidden = true
            self.verticalChallengerVsFollow.constant = -50
        }
    }
    //MARK: IBaction
    
    @IBAction func followTouched(_ sender: AnyObject) {
        self.showHudWithString("")
        AppRestClient.sharedInstance.follow(user!.idUser, isFollow: !user!.isFollowing) { (success, error) -> () in
            if(success){
                self.user!.toggleIsFollowedByCurrentUser()
                self.updateFollowState()
                self.updateTitleFollow()
                if(self.user!.isFollowing){
                    AuthToken.sharedInstance.currentUser?.followingCount += 1
                }else{
                    AuthToken.sharedInstance.currentUser?.followingCount -= 1
                }
            }else{
                self.showGeneralDialog()
            }
            self.hideHudLoading()
        }
    }

    @IBAction func sendChallengeTouched(_ sender: AnyObject) {
    }
    @IBAction func listCheckTouched(_ sender: AnyObject) {
//        var completedVC = storyboard?.instantiateViewControllerWithIdentifier("CompletedResponseViewControllerID") as! CompletedResponseViewController
//        completedVC.userID = user?.idUser
//        self.navigationController?.pushViewController(completedVC, animated: true)
        
        let newVC = storyboard!.instantiateViewController(withIdentifier: "NewsViewControllerID") as! NewsViewController
        newVC.userID = user?.idUser
        newVC.isCompletedRequest = true
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    @IBAction func segmenTouched(_ sender: AnyObject) {
        if(segmentUser.selectedSegmentIndex == 0){
            
        }else{
            
        }
    }
    func updateScrollView(){
        var i = 0
        //update infor scroll view
       
        for response in self.responses{
            let originX = CGFloat(i) * 65 + 10
            let frameImage = CGRect(x: originX , y: 5, width: 60, height: 60)
            let userImageView =  UIImageView(frame: frameImage)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.imageTouched(_:)))
            tapGesture.numberOfTapsRequired = 1
            userImageView.addGestureRecognizer(tapGesture)
            userImageView.isUserInteractionEnabled = true
            
            let userUrl = URL(string: response.photoUrl!)
            userImageView.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
            replyImgScrollView.addSubview(userImageView)
            userImageView.tag = i + 11
            i += 1
        }
        replyImgScrollView.contentSize = CGSize( width: CGFloat(i) * 65 + 20 , height: 60)
    }
    func getResponseImage(_ pageIndex:Int){
        //show loading 
        self.showHudLoadingInView(replyImgScrollView)
        
        AppRestClient.sharedInstance.getResponse(pageIndex, userId: user!.idUser) { (responsesLoad, error) -> () in

            self.hideHudLoadingInView(self.replyImgScrollView)
            if(responsesLoad != nil){
                self.responses += responsesLoad!

                if responsesLoad!.count == AppRestClient.sharedInstance.Page_Count {
                    self.getResponseImage(pageIndex + 1)
                }else{
                    self.updateScrollView()
                }
                
            }else{
                self.showGeneralDialog()
            }

        }
    }
}
