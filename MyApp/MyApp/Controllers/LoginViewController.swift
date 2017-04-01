//
//  ViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/7/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: BaseViewController {


//    var isNeedGetConfiguration = true
    var fbloginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkAuthenticate()
        
    }
    func checkAuthenticate(){
        if (User.getToken() != nil){
            print(" user tokenn \(User.getToken()!)")
            self.showHudWithString("")
            AppRestClient.sharedInstance.checkAuthentication(User.getToken()!, callback: { (sucess, error) -> () in
                self.hideHudLoading()
                if (sucess){
                    self.gotoMainScreen()
                }else{
                    User.logOut()
                    self.loginFaceBookTouched(self)

                }
            })
        }else{

            self.delay(0.5, closure: { 
                self.loginFaceBookTouched(self)
            })
            
        }
    }
    
    func getConfigurationService(){
        self.showHudWithString("")

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginFaceBookTouched(_ sender: AnyObject) {
        self.showHudWithString("")
        if FBSDKAccessToken.current() != nil {
            print("has login \(FBSDKAccessToken.current().tokenString)")
            self.loginWithFacebookToken()
            
        }else{
            
            fbloginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (
                result, error) in
                
                if FBSDKAccessToken.current() != nil {
                    print("has login \(FBSDKAccessToken.current().tokenString)")
                    self.loginWithFacebookToken()
                }else{
                    self.hideHudLoading()
                }
            }    
        }
        
    }

    func loginWithFacebookToken(){
        if let currentToken  = FBSDKAccessToken.current().tokenString {
            AppRestClient.sharedInstance.loginWithFacebook(currentToken, callback: { (success, error) in
                if success {
                    print("login success")
//                    self.gotoMainScreen()
                    self.checkAuthenticate()
                }else{
                    print("error")
                    self.showDialogError(error?.description)

                }
                self.hideHudLoading()
            })
        }else{
            self.hideHudLoading()
            self.showDialogError("Unknown error")
        }
        
    }
    @IBAction func loginTwitterTouched(_ sender: AnyObject) {
        self.loginWithKeyword("twitter")
    }
    
    @IBAction func loginGoogleTouched(_ sender: AnyObject) {
        self.loginWithKeyword("google")
    }
    
    @IBAction func loginMicrosoftTouched(_ sender: AnyObject) {
        self.loginWithKeyword("microsoft")
    }
    func gotoMainScreen(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.goToMainViewController()
    }
    func loginWithKeyword(_ provide:String){
        
    }
}

