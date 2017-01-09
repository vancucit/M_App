//
//  UserApi.swift
//  MyApp
//
//  Created by Cuc Nguyen on 12/20/16.
//  Copyright © 2016 Kuccu. All rights reserved.
//

import UIKit
import Alamofire

extension AppRestClient{
    //new 
    
    func loginWithFacebook(_ tokenString:String,  callback:@escaping (Bool, String?) -> ()) {
        let params = ["access_token": tokenString]
        print("params : \(params)")
        let urlFacebook = getAbsoluteUrl("social/token/facebook") + String(format:"?fb_access_token=%@",tokenString)
        
//        let urlFacebook = getAbsoluteUrl("social/token/facebook")
        Alamofire.request(urlFacebook, method:.post,  parameters: nil).responseJSON() { result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    if let aDict = objectResopnse as? NSDictionary {
                        if let tokenStr = aDict["id_token"] as? String {
                            //save token_string
                            
                            
                            User.saveToken(tokenStr)
                            callback(true, nil)
                        }else{
                            callback(false,objectResopnse as? String)
                        }
                        
                    }else{
                        callback(false,objectResopnse as? String)
                    }
                    
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
    }
    
//    func getConfiguration(_ callback:@escaping (Configuration?, NSError?) -> ()){
//        Alamofire.request(getAbsoluteUrl("configurations"), method: .get , parameters: nil).responseJSON{ result in
//            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess,error) -> () in
//                if(isSuccess == true){
//                    let objectResopnse = objectResopnse as! NSDictionary
//                    
//                    let configuration = Configuration(jsonDict: objectResopnse)
//                    callback(configuration, nil)
//                }else{
//                    callback(nil,error)
//                }
//            })
//        }
//    }
    
    func getAccessToken(_ callback:@escaping (Bool, String?) -> ()) {
        Alamofire.request(getAbsoluteUrl("user/access-token"),method:.get,  parameters: nil).responseJSON { result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true, nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
        
    }
    func login(_ uuidDevice:String, providestr:String, user:MSUser, callback:@escaping ((Bool,String?) -> ())){
        let params = ["deviceID": uuidDevice,"linkType":providestr,"authenticationId":user.userId, "authenticationToken":user.mobileServiceAuthenticationToken];
        print("params : \(params)")
        Alamofire.request(getAbsoluteUrl("user/login"), method:.post,  parameters: params).responseJSON() { result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    let objResponse = objectResopnse as! NSDictionary
                    AuthToken.sharedInstance.setToken(objResponse, provide: providestr)
                    AuthToken.sharedInstance.cacheUserToken()
                    callback(true, nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
    }

    //MARK: User
    func checkAuthentication(_ authToken:String, callback: @escaping (Bool,  String?) ->() ){
//        self.addAuthToken(authToken)
//        var xHTTPAdditionalHeaders: [AnyHashable: Any] = ["Authorization": "Bearer " + authToken]
        let headerRequest = ["Authorization":"Bearer " +  User.getToken()!]

        request( getAbsoluteUrl("api/account"), method:.get, parameters: nil, headers:headerRequest).responseJSON(){ result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    let dicUser = objectResopnse as! NSDictionary
                    User.shareInstance.setUserFromDic(dicUser)
//                    AuthToken.sharedInstance.currentUser = User(jsonDict: dicUser)
                    callback(true, nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
        
    }
    func getUser(_ idUser:String, callback: @escaping (User?,  String?) -> ()){
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let urlRequest = getAbsoluteUrl("user/get/") + idUser
        
        Alamofire.request(urlRequest, method:.get, parameters: nil).responseJSON() { result in
            self.handleCommonResponseWithData(result,  callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    let dictUser = objectResopnse as! NSDictionary
                    let newUser = User(jsonDict: dictUser)
                    callback(newUser, nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    
    func getListUsers(_ pageIndex:Int, keyword:String, callback:@escaping ([User]?, String?) ->()){
        let urlRequest = getAbsoluteUrl("api/users?page=0&size=100")

//        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
//        let params = ["page": pageIndex as AnyObject,"limit":Page_Count as AnyObject,"keyword":keyword as AnyObject] as [String:AnyObject]
        let headerRequest = ["Authorization":"Bearer " +  User.getToken()!]

        request(urlRequest, method:.get, parameters: nil , headers:headerRequest ).responseJSON(){ result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    let arrUser = objectResopnse as! [NSDictionary]
                    var users = [User]()
                    for dictUser  in arrUser{
                        let newUser = User(jsonDict: dictUser)
                        users.append(newUser)
                    }
                    callback(users, nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    
    func getFriends(_ pageIndex:Int, keyword:String, callback:@escaping ([User]?, String?) ->()){
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let params = ["page": pageIndex as AnyObject,"limit":Page_Count as AnyObject,"keyword":keyword as AnyObject] as [String:AnyObject]
        request(getAbsoluteUrl("user/friends"), method:.post, parameters: params).responseJSON(){ result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    let arrUser = objectResopnse as! [NSDictionary]
                    var users = [User]()
                    for dictUser  in arrUser{
                        let newUser = User(jsonDict: dictUser)
                        users.append(newUser)
                    }
                    callback(users, nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    func getTop50Users(_ callback:@escaping ([User]?,String?) ->()){
        let urlRequest = getAbsoluteUrl("api/users?page=0&size=100")
        //"user/top50"
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        request(getAbsoluteUrl(urlRequest), method:.get, parameters: nil).responseJSON(){ result in
            self.handleCommonResponseWithData(result,  callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var arrUser = objectResopnse as! [NSDictionary]
                    var users = [User]()
                    for dictUser  in arrUser{
                        var newUser = User(jsonDict: dictUser)
                        users.append(newUser)
                    }
                    callback(users, nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    //update
    func updateProfile(_ name:String, location:String, website:String,bio:String,isPublic:Bool, avatarUrl:String?,gender:String, birthday: String, callback: @escaping (Bool,  String?) -> ()){
        var avatarStr = ""
        if(avatarUrl != nil){
            avatarStr = avatarUrl!
        }
        var publicStr = "false"
        if(isPublic){
            publicStr = "true"
        }
        let params = ["name":name as AnyObject,"location":"" as AnyObject,"bio":bio as AnyObject,"website":"" as AnyObject,"isPublic":publicStr as AnyObject,"avatarUrl":avatarStr as AnyObject,"gender":"Male" as AnyObject,"birthday":"1987-02-14"] as [String:Any]
        
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        
        Alamofire.request(getAbsoluteUrl("user/update"), method:.post, parameters: params).responseJSON() { result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true, nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
    }
    


}
