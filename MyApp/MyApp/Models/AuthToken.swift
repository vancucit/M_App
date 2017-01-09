//
//  AuthToken.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class AuthToken: NSObject {


    class var sharedInstance: AuthToken {
        
        struct Static {
            static let instance : AuthToken = AuthToken()
            static var token: Int = 0
        }
        
        return Static.instance
    }
    
    //
    //Variable
    //
    var authenticationToken:String?
    var currentUser:User?
    var provideStr:String?
    
    
     func resoreAuthToken() -> Bool{
        var tokenJson = UserDefaults.standard.string(forKey: "AuthenticationToken")
        if (tokenJson != nil && tokenJson!.characters.count > 0){
            if let data = UserDefaults.standard.object(forKey: "currentUser") as? Data {
                
               self.currentUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User
                self.authenticationToken = tokenJson
                self.provideStr = UserDefaults.standard.string(forKey: "AUTH_PROVIDER")
                return true
            }
            return false
            
        }
        return false
    }
    
    func cacheUser(_ dictUser:NSDictionary, provideStr:String){
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: "currentUser")
        UserDefaults.standard.set(dictUser["AuthenticationToken"] as! String, forKey: "AuthenticationToken")
        UserDefaults.standard.set(provideStr, forKey: "AUTH_PROVIDER")
        
    }
    func setToken(_ dicObj:NSDictionary, provide:String){
        authenticationToken = dicObj["AuthenticationToken"] as? String
        currentUser = User(jsonDict: (dicObj["User"] as! NSDictionary))
        provideStr = provide
    }
    func cacheUserToken(){
        var data:Data?
        if(currentUser != nil){
            data = NSKeyedArchiver.archivedData(withRootObject: currentUser!)
        }

        UserDefaults.standard.set(data, forKey: "currentUser")
        UserDefaults.standard.set(authenticationToken, forKey: "AuthenticationToken")
        UserDefaults.standard.set(provideStr, forKey: "AUTH_PROVIDER")
   
    }
    func logout(){
        authenticationToken = nil
        currentUser = nil
        provideStr = nil
        cacheUserToken()
    }
    class func isCurrentUser(_ userID:String) -> Bool {
        if(AuthToken.sharedInstance.currentUser!.idUser == userID){
            return true
        }
        return false
    }
}
