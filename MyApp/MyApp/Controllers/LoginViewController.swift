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
//        if(isNeedGetConfiguration){
//            self.getConfigurationService()
//        }

        //checkAuthenticate
        //
        if (User.getToken() != nil){
            print(" user tokenn \(User.getToken()!)")
            self.showHudWithString("")
            AppRestClient.sharedInstance.checkAuthentication(User.getToken()!, callback: { (sucess, error) -> () in
                self.hideHudLoading()
                if (sucess){
                    self.gotoMainScreen()
                }else{
                    User.logOut()
                }
            })
        }
        
    }
    func getConfigurationService(){
        self.showHudWithString("")

        MyAppService.sharedInstance.getConfigurationService { (success, error) -> () in
            if(success){
                if(AuthToken.sharedInstance.resoreAuthToken()){
                    AppRestClient.sharedInstance.checkAuthentication(AuthToken.sharedInstance.authenticationToken!, callback: { (sucess, error) -> () in
                        self.hideHudLoading()
                        if (sucess){
                            self.gotoMainScreen()
                        }else{
                            AuthToken.sharedInstance.logout()
                        }
                    })
                }else{
                    self.hideHudLoading()                    
                }
            }else{
                self.showDialog("Service error", contentStr: "Can't get information service")
                self.hideHudLoading()
            }

        }
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
                }
            }    
        }
        
    }

    func loginWithFacebookToken(){
        if let currentToken  = FBSDKAccessToken.current().tokenString {
            AppRestClient.sharedInstance.loginWithFacebook(currentToken, callback: { (success, error) in
                if success {
                    print("login success")
                    self.gotoMainScreen()
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
        if(MyAppService.sharedInstance.client != nil){
            self.showHudWithString("")
//            self.myAppSerice.client?.l
           let controller =  MyAppService.sharedInstance.client?.loginViewController(withProvider: provide, completion: { (user, error) -> Void in
            if(error == nil && user != nil){
                let uuidDevice = UIDevice.current.identifierForVendor?.uuidString
                AppRestClient.sharedInstance.login(uuidDevice!, providestr: provide, user: user!, callback: { (success, error) -> () in
                    self.hideHudLoading()
                    if(success){
                        self.gotoMainScreen()
                    }else{
                        self.showDialog("Error", contentStr: "Login failed. Try again")
                    }
                    
                })
            }else{
                self.hideHudLoading()

                self.showGeneralDialog()
            }
            self.dismiss(animated: true, completion: nil)
            })
            self.present(controller!, animated: true, completion: nil)
        }else{
//            self.getConfigurationService()
        }
    }
}

