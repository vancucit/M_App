//
//  PipeFishReshClient.swift
//  PipeFish
//
//  Created by Cuccku on 10/20/14.
//  Copyright (c) 2014 ChangeAbleWorld. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwifteriOS

//let BaseHost = "api.pipefish.com"
let BaseHost = "api-staging.pipefish.com"
let BaseUrl = "http://" + BaseHost + "/2.0/"

class PipeFishReshClient {
    class var sharedInstance : PipeFishReshClient {
        struct Static {
            static let instance : PipeFishReshClient = PipeFishReshClient()
        }
        return Static.instance
    }

    
    func  getAbsoluteUrl(relativeUrl: String) -> String{
        return BaseUrl + relativeUrl;
    }
    
    func handleCommonResponseWithDataDetail(aData:AnyObject?, error:NSError?, isNeedShowDialog:Bool?, callBack:(AnyObject?,Bool)->())->(){
        if(error != nil && isNeedShowDialog == true){
            //show dialog here
            callBack(nil,false)
            //var alertView = UIAlertView(title: NSLocalizedString("GeneralErorTitle", comment: "APIerror"), message: NSLocalizedString("GeneralErrorMessage", comment: "APIerror"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
            //alertView.show()
        }else{
            //            println(aData)
            if let stringData = aData as? String{
                var errorParse:NSError?
                var dataResponse: NSData = stringData.dataUsingEncoding(NSUTF8StringEncoding)!
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataResponse, options: NSJSONReadingOptions.AllowFragments, error:&errorParse)
                if let unwrappedData = json as? NSDictionary {
                    if let successAuthent = unwrappedData["success"] as? Bool{
                        if successAuthent{
                            callBack(unwrappedData["data"], true)
                        }else{
                            callBack(unwrappedData["data"], false)
                        }
                    }else{
                        callBack(nil, false)
                    }
                    
                }
            }else if let unwrappedData = aData as? NSDictionary {
                if let successAuthent = unwrappedData["success"] as? Bool{
                    if successAuthent{
                        callBack(unwrappedData["data"], true)
                    }else{
                        callBack(unwrappedData["data"], false)
                    }
                }else{
                    callBack(nil, false)
                }
            }else if let dataResponse = aData as? NSData{
                var errorParse:NSError?
                
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataResponse, options: NSJSONReadingOptions.AllowFragments, error:&errorParse)
                if let unwrappedData = json as? NSDictionary {
                    if let successAuthent = unwrappedData["success"] as? Bool{
                        if successAuthent{
                            callBack(unwrappedData["data"], true)
                        }else{
                            callBack(unwrappedData["data"], false)
                        }
                    }else{
                        callBack(nil, false)
                    }
                    
                }
            }else{
                callBack(nil, false)
            }
        }
        
    }
    func handleCommonResponseWithData(aData:AnyObject?, error:NSError?, callBack:(AnyObject?,Bool)->())->(){
        self.handleCommonResponseWithDataDetail(aData, error: error,isNeedShowDialog:true, callBack: callBack)
    }
    
    func ping()->(){
        var absoluteUrl = getAbsoluteUrl("ping")
        let url = NSURL(string: absoluteUrl)
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            if let unwrappedData = data as? [NSDictionary] {
                let jsonResult = JSON(unwrappedData)
                
            }else{
            }
        })
    }
    //MARK: User
    func checkAuthentication(callback: (User?,  NSError?) ->() ){
        request(.GET, getAbsoluteUrl("auth"), parameters: nil).responseJSON({
            (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var dataUser = objectResopnse as NSDictionary
                    var json = JSON(dataUser)
                    User.shareInstance.setUser(json)
                    callback(User.shareInstance, error)
                }else{
                    println("contetn errr \(objectResopnse)")
                    if let contentStr = objectResopnse as? String{
                        if(contentStr == "INVALID"){
                        }
                    }
                    callback(nil,nil)
                }
            })
          
        })
    }
   
    func verifyUserWithEmail(emailUser:String, confirmCode:String, callback: (User?,  NSError?, String?) ->()){
        var params = ["email": emailUser, "verification_code":confirmCode,"client_os":"ios"]
        
        var tokenDevice = NSUserDefaults.standardUserDefaults().objectForKey("device_token") as String!
        if tokenDevice != nil && tokenDevice.isEmpty == false{
            params.updateValue(tokenDevice, forKey: "device_token")
        }
        
        request(.POST, getAbsoluteUrl("auth/verify"), parameters: params).responseJSON({(request, response, data, error) in
            
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                println(objectResopnse)
                if(isSuccess == true){
                    let json = JSON(objectResopnse!)
                    User.shareInstance.setUser(json)
                    callback(User.shareInstance, error,nil)
                }else{
                    callback(nil, error,nil)
                }
            })
        })
    }
    func registerUserWith(keyType:KeyTypeStr, keyValue:String, screenName: String, posterPath: String,  keyCode:String?, callback: (User?,  NSError?) ->() ){
        var uuidStr = NSUUID().UUIDString

        var localeObj = NSLocale.currentLocale()
        var langueCode = localeObj.objectForKey(NSLocaleLanguageCode) as String
        var countryCode = localeObj.objectForKey(NSLocaleCountryCode) as String
        var registerLangue = langueCode + "_"
        registerLangue = registerLangue + countryCode
        
        var params = ["key_type": keyType.rawValue,"key_value":keyValue,"name":screenName, "poster_path":posterPath, "language":registerLangue, "client_os":"ios"]
        if keyCode != nil{
            params.updateValue(keyCode!, forKey: "key_code")
        }
        var tokenDevice = NSUserDefaults.standardUserDefaults().objectForKey("device_token") as String!
        if tokenDevice != nil && tokenDevice.isEmpty == false{
            params.updateValue(tokenDevice, forKey: "device_token")
        }
        println(params)
        
        if(keyType == KeyTypeStr.KeyTypeTwitter){
            request(.POST, getAbsoluteUrl("users"), parameters: params).responseJSON({
                (request, response, data, error) in

                println(request)
                println(response)
                println(data)
                self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                    if(isSuccess == true){
                        var dataUser = objectResopnse as NSDictionary
                        var json = JSON(dataUser)
                        User.shareInstance.setUser(json)
                        callback(User.shareInstance, error)
                    }else{
                        println("contetn errr \(objectResopnse)")
                        callback(nil,nil)
                    }
                })
            })
        }else{
            request(.POST, getAbsoluteUrl("users"), parameters: params).responseString({ (request, urlResponse, stringRe, error) -> Void in
                
                self.handleCommonResponseWithData(stringRe, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                    if(isSuccess == true){
                        callback(nil, nil)
                    }else{
                        println("contetn errr \(objectResopnse)")
                        callback(nil, NSError(domain: "register.valid", code: 1456, userInfo: ["content":"issueWhenRegister"]))
                    }
                })
            })
        }
    }
    func loginWithUserName(userName:String, keyCode:String, callback: (User?,  NSError?, Bool) ->() ){
        var params = ["email": userName, "password":keyCode,"client_os":"ios"]
        var tokenDevice = NSUserDefaults.standardUserDefaults().objectForKey("device_token") as String!
        if tokenDevice != nil && tokenDevice.isEmpty == false{
            params.updateValue(tokenDevice, forKey: "device_token")
        }
        request(.POST, getAbsoluteUrl("auth/login"), parameters: params).responseJSON({
            (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var dataUser = objectResopnse as NSDictionary
                    var json = JSON(dataUser)
                    User.shareInstance.setUser(json)
                    callback(User.shareInstance, error, true)
                }else{
                    if(objectResopnse != nil && (objectResopnse as String == "NOT_VERIFIED")){
                        callback(nil,nil, false)
                    }
                    else{
                        callback(nil,nil, true)
                    }
                }
            })
        })
    }
    func resendVerificationCodeWithEmail(emailUser:String,typeStr:String, callback: (Bool,  NSError?) ->()) -> (){
        let params = ["email":emailUser,"type":typeStr]
        request(.POST, getAbsoluteUrl("auth/verify/resend"), parameters: params).responseJSON { (reqeuest, urlResponse, data, error) -> Void in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                println(error)
                if(isSuccess == true){
                    callback(true, error)
                }else{
                    callback(false, error)
                }
            })
        }
    }
    func forgotPassWithEmail(emailUser:String, callback: (Bool, NSError?) ->()) ->(){
        let params = ["email":emailUser]
        request(.POST, getAbsoluteUrl("auth/password/forgot"), parameters: params).responseString { (reqeuest, urlResponse, result, error) -> Void in
            self.handleCommonResponseWithData(result, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                callback(isSuccess,error)
            })
        }
    }
    func resetPasswordWithEmail(emailUser:String, confirmCode:String, newPassCode:String, callback: (Bool, NSError?) ->()) ->(){

        let params = ["email":emailUser,"verification_code":confirmCode,"password":newPassCode]

        request(.POST, getAbsoluteUrl("auth/password/reset"), parameters: params).responseString { (reqeuest, urlResponse, result, error) -> Void in
            self.handleCommonResponseWithData(result, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                callback(isSuccess,error)
            })
        }
    }
    func logout(deviceId: String , callback: (Bool?) ->() ){
        var url = getAbsoluteUrl("auth/logout");
        
        var params = ["client_os": "ios"]
        var tokenDevice = NSUserDefaults.standardUserDefaults().objectForKey("device_token") as String!
        if tokenDevice != nil && tokenDevice.isEmpty == false{
            params.updateValue(tokenDevice, forKey: "device_token")
        }
        request(.POST, url, parameters: params).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                callback(isSuccess)
            })
        })
    }
    
    func saveProfileInfo(name: String, location: String, website: String, bio: String, callback: (User?,  NSError?) ->() ){
        var url = getAbsoluteUrl("users/")
        var userData = "{\"name\":\"" + name + "\",\"location\":\"" + location + "\"," + "\"website\":\"" + website + "\",\"bio\":\"" + bio + "\"}"
        let params = ["user" : userData]
        request(.PATCH, url, parameters: params).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var dataUser = objectResopnse as NSDictionary
                    var json = JSON(dataUser)
                    User.shareInstance.setUser(json)
                    callback(User.shareInstance, error)
                }else{
                    println("contetn errr \(objectResopnse)")
                    callback(nil,nil)
                }
            })
            
        })
    }

    func getUserFromQueryUserName(searchValueParam: String, pageIndex: String, callback: ([User]?,  NSError?) ->() ){
        var searchValue = searchValueParam.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var queryString = "?page="+String(pageIndex)+"&limit=" + String(ConstantPipeFish.findPeoplePageSize) + "&name=" + searchValue
        
        var absoluteUrl = getAbsoluteUrl("search/users") + queryString
        var changedUrl = absoluteUrl.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let url = NSURL(string: changedUrl)
        var userList = [User]()
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var dataUser = objectResopnse as [NSDictionary]
                    let jsonResult = JSON(dataUser)
                    var userCount = dataUser.count
                    
                    for(var index = 0;index < userCount;++index){
                        var json = JSON(dataUser[index])
                        var userInfo = User(json: json)
                        userList.append(userInfo)
                    }
        
                    callback(userList, error)
                }else{
                    callback(nil,nil)
                }
            })
            
        })
    }
    
    func markNotificationsAsRead(notificationId: Int, callback: (Bool,  NSError?) ->() ){
        var absoluteUrl = getAbsoluteUrl("notifications/") + String(notificationId)
        let url = NSURL(string: absoluteUrl)
        
        request(.POST, url!, parameters: nil).responseJSON({(request, response, data, error) in
            
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true, error)
                }else{
                    callback(false, error)
                }
            })
        })
    }
    
    func getNotificationCount(callback: (String?,  NSError?) ->() ){
        var absoluteUrl = getAbsoluteUrl("notifications")
        let url = NSURL(string: absoluteUrl)
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithDataDetail(data, error: error,isNeedShowDialog:false, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    if let unwrappedData = objectResopnse as? NSInteger {
                        var number = String(unwrappedData)
                        callback(number ,error )
                    }else{
                        callback("0", error)
                    }
                    
                }else{
                    callback("0", error)
                }
            })
        })
    }
    func getNotificationsWithID(idNotif: Int, callback: (Notification?,  NSError?) ->() ){
        

        var absoluteUrl = getAbsoluteUrl("notifications/") + String(idNotif)
        let url = NSURL(string: absoluteUrl)
        var notifications = [Notification]()
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            
            self.handleCommonResponseWithDataDetail(data, error: error, isNeedShowDialog:false, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    if let unwrappedData = objectResopnse as? NSDictionary {

                        var notification = Notification(aDictMessage: unwrappedData)
                        callback(notification, error)
                    }else{
                        callback(nil, error)
                    }
                    
                }else{
                    callback(nil, error)
                }
            })
        })
    }
    func getNotifications(pageIndex: Int, callback: ([Notification]?,  NSError?) ->() ){

        var queryString = "&page="+String(pageIndex)+"&limit=" + String(ConstantPipeFish.findPeoplePageSize)            
        var absoluteUrl = getAbsoluteUrl("notifications?show=true") + queryString
        let url = NSURL(string: absoluteUrl)
        var notifications = [Notification]()
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            
            self.handleCommonResponseWithDataDetail(data, error: error, isNeedShowDialog:false, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    if let unwrappedData = objectResopnse as? [NSDictionary] {
                        let jsonResult = JSON(unwrappedData)
                        var messageCount = unwrappedData.count
                        
                        for(var index = 0;index < messageCount;++index){
                            var messageInfo = Notification(aDictMessage: unwrappedData[index])
                            notifications.append(messageInfo!)
                        }
                        
                        callback(notifications, error)
                    }else{
                        callback(nil, error)
                    }
                    
                }else{
                    callback(nil, error)
                }
            })
        })
    }
    
  
    func getMsgLinkInfo(linkAddress: String, callback: (MessageChatInfor?,  NSError?) ->() ){
        
        var absoluteUrl = getAbsoluteUrl("assets/links")
        let url = NSURL(string: absoluteUrl)
        var params = ["url": linkAddress]
        request(.POST, url!, parameters: params).responseJSON({(request, response, data, error) in
            if(error == nil){
                //has call update success
                MessageChatInforHelper.updateMsgChatInforIsLoad(linkAddress, isLoadLink: true)
            }else{
                callback(nil, error)
            }
            self.handleCommonResponseWithDataDetail(data, error: error, isNeedShowDialog:false, callBack: { (objectResopnse, isSuccess) -> () in
                var linkInfo = MessageChatInforHelper.getMsgChatInforByOriginalLink(linkAddress)
                if(isSuccess == true){
                    if let unwrappedData = objectResopnse as? NSDictionary {
                        var linkInfoUpdate = MessageChatInforHelper.updateMsgChatInforWithOriginalLink(linkAddress, linkInfo: unwrappedData)
                        callback(linkInfoUpdate, error)
                    }else{

                        callback(nil, error)
                    }
                    
                }else{
//                    linkInfo.isLoadLink = false
                    callback(linkInfo, error)
                }
            })
        })
    }
    func loadUserPhoto(pageIndex: Int,userId:Int, callback: ([PhotoInfo]?,  NSError?) ->() ){
        
        var queryString = "?page="+String(pageIndex)+"&limit=" + String(ConstantPipeFish.photoGalleryPageSize)
        var relativePath = "users/" + String(userId) + "/photos"
        var absoluteUrl = getAbsoluteUrl(relativePath) + queryString
        
        let url = NSURL(string: absoluteUrl)
        var photosInfo = [PhotoInfo]()
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
        
            if(error == nil){
                if let unwrappedData = data as? [NSDictionary] {
                    let jsonResult = JSON(unwrappedData)
                    var photoCount = unwrappedData.count
                    
                    for(var index = 0;index < photoCount;++index){
                        var photoResult = JSON(unwrappedData[index])
                        var url = photoResult["url"].string!
                        var imagePath = ConstantPipeFish.ConvertToImagePath(url, hasThumnail: true)
                        var photoInfo = PhotoInfo(thumbnaiUrl: imagePath, PhotoUrl: url, PhotoId: url)
                        photosInfo.append(photoInfo)
                    }
                    
                    callback(photosInfo, error)
                }else{
                    callback(nil, error)
                }
                
            }else{
                callback(nil, error)
            }
        })
    }
    
    func followAnUser(userId: Int, callback: (Bool?) ->() ){
        var url = getAbsoluteUrl("follows/") + String(userId)
        //let param = ["type" : "user"]
        request(.POST, url, parameters: nil).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess){
                    callback(true)
                }
                else{
                    callback(false)
                }
            })
        })
    }
    
    func unFollowAnUser(userId: Int, callback: (Bool?) ->() ){
        var url = getAbsoluteUrl("follows/") + String(userId)
        //let param = ["type" : "user"]
        request(.DELETE, url, parameters: nil).responseJSON({(request, response, data, error) in
            
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess){
                    callback(true)
                }
                else{
                    callback(false)
                }
            })
        })
    }
    
    func getListOfFollowings(userId: Int, isGetFollowing: Bool,pageIndex:Int, callback: ([User]?,  NSError?) ->() ){
        
        var absoluteUrl = ""
        
        var queryString = "?page="+String(pageIndex)+"&limit=" + String(ConstantPipeFish.findPeoplePageSize)
        
        if(isGetFollowing){
            absoluteUrl = getAbsoluteUrl("users/") + String(userId) + "/following" + queryString;
        }
        else{
            absoluteUrl = getAbsoluteUrl("users/") + String(userId) + "/followers" + queryString;
        }
        
        let url = NSURL(string: absoluteUrl)
        var userList = [User]()
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    if let unwrappedData = objectResopnse as? [NSDictionary] {
                        
                        let jsonResult = JSON(unwrappedData)
                        var userCount = unwrappedData.count
                        
                        for(var index = 0;index < userCount;++index){
                            var json = JSON(unwrappedData[index])
                            var userInfo:User
                            userInfo = User(json: json)
                            userList.append(userInfo)
                        }
                        
                        callback(userList, error)
                    }else{
                        callback(nil, error)
                    }
                }else{
                    callback(nil, error)
                }
            })
        })
    }
    
    func getCurrentUserInfo(userId: Int, callback: (User?,  NSError?) ->() ){
        
        var absoluteUrl = getAbsoluteUrl("users/") + String(userId);
        let url = NSURL(string: absoluteUrl)
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var dataUser = objectResopnse as NSDictionary
                    var json = JSON(dataUser)
                    var aUser = User()
                    aUser.setUser(json)
                    callback(aUser, error)
                }else{
                    callback(nil,nil)
                }
            })
        })
    }
    
    func getImagePath(imageFormat: String, callback: (String?,  NSError?) ->() ){        
        var absoluteUrl = getAbsoluteUrl(imageFormat)
        let url = NSURL(string: absoluteUrl)
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var dataUser = objectResopnse as NSString
                    callback(dataUser, error)
                }else{
                    callback(nil,nil)
                }
            })
        })
    }
    
    func registerUserKey(value: String, code: String, keyType:String, callback: (Bool,  String) -> () ){
        var absoluteUrl = getAbsoluteUrl("auth/link")
        let url = NSURL(string: absoluteUrl)
        let param = ["key_value" : value,"key_type" : keyType, "key_code" : code]
        
        request(.POST, url!, parameters: param ).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true, "")
                }else{
                    callback(false, "IN_USED")
                }
            })
        })
    }
    
    func verifyKey(keyValue: String, keyType: String, code: String,callback: (Bool,  NSError?) ->()){
        let params = ["value": keyValue,"type": keyType, code: code]
        var absoluteUrl = getAbsoluteUrl("keys/verify/code")
        let url = NSURL(string: absoluteUrl)
        
        request(.POST, url!, parameters: params ).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true, error)
                }else{
                    callback(false, error)
                }
            })
        })
    }
    
    func resendUserkey(keyId: Int,callback: (Bool,  NSError?) ->()){
        let params = ["id": NSNumber(integer: keyId)]
        var absoluteUrl = getAbsoluteUrl("keys/resend")
        let url = NSURL(string: absoluteUrl)
        
        request(.POST, url!, parameters: params ).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true, error)
                }else{
                    callback(false, error)
                }
            })
        })
    }
    
    func unLinkKey(key_type: String,key_value:String, callback: (Bool,  NSError?) ->() ){
        var url = getAbsoluteUrl("auth/unlink")
        let params = ["key_value" : key_value,"key_type" : key_type]
        request(.POST, url, parameters: params ).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true,nil)
                }else{
                    callback(false, error)
                }
            })
        })
    }

    func inviteUserByEmail(listUserStr: String ,callback: (Bool,  NSError?)->()){
        let params = ["emails" : listUserStr]
        var url = getAbsoluteUrl("users/invite");
        
        request(.POST, url, parameters: params ).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true,nil)
                }else{
                    callback(false, error)
                }
            })
        })
    }
    
    //final String url = getAbsoluteUrl("users/") + userId + "/following";
    
    //MARK: messsage
    func getListMessage(roomID:Int,  limitNumber:Int, lastMessageID:Int,callback: (NSArray?,NSError?) -> ()){
        var urlListMessage = getAbsoluteUrl("chatrooms/") + String(roomID) + "/messages?limit=\(limitNumber)" + "&last_message_id=\(lastMessageID)"
        println("getting... \(urlListMessage)")

        request(.GET, urlListMessage, parameters: nil).responseJSON({
            (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if let unwrappedData = objectResopnse as? NSArray{
                    callback(unwrappedData,nil)
                }else{
                    callback(nil, error)
                }
            })
        })
    }
    func getMessageInforById(messageID:Int ,callback: (MessageChat?,NSError?) -> ()){
        var absoluteUrl = getAbsoluteUrl("messages/") + String(messageID);
        let url = NSURL(string: absoluteUrl)
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var dataMsg = objectResopnse as NSDictionary
                    if let messageChat = MessageChat(aDictMessage: dataMsg){
                        callback(messageChat, error)
                    }else{
                        callback(nil, error)
                    }
                }else{
                    callback(nil,nil)
                }
            })
            
        })

    }
    
    func postMessage(messagePost:XMPPMessage, chatroomID:Int, callback:((MessageChat?, NSError?) -> ()) ){
//        var bodySttr = messagePost.stringValue()
        var posterPath = messagePost.getPosterPath()
        var posterType = messagePost.getPosterType()
        let params = ["poster_path" : posterPath,"poster_type" : posterType, "uuid":messagePost.getUUID()!, "content":messagePost.getContentMessage(),"media_url":messagePost.getImageUrl()]
        
//
//        var bodyStrr = messagePost.getBodyElement()!.stringValue()!
        var messagesPostURL = getAbsoluteUrl("chatrooms/") + String(chatroomID) + "/message"
        
        Alamofire.request(.POST, messagesPostURL, parameters:params).responseJSON({
            (request, response, data, error) in
            
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    if let newMessage = MessageChat(object: objectResopnse){
                        callback(newMessage, error)
                    }else{
                        callback(nil, error)
                    }
                }else{
                    callback(nil,error)
                }
            })            
        })
//        PipeFishAPI.sharedInstance.makeHTTPPostRequest(messagesURL, body: bodyStrr, callback: { (dictResponse, error) -> () in
//            if let unwrappedData = dictResponse as? NSDictionary {
//                if let successAuthent = unwrappedData["success"] as? Bool{
//                    callback(successAuthent, nil)
//                }else{
//                    callback(false, nil)
//                }
//            }else{
//                    callback(false, error)
//        }
//        
//        })

    }
    func deleteMessage(messageID:Int, callBack:(Bool?, NSError?) -> ()){
        
        let urlPost = getAbsoluteUrl("chatrooms/message")
        let params = ["id": messageID]

        request(.DELETE, urlPost, parameters: params).response { (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                callBack(isSuccess,error)
            })
        }
    }
    
    //MARK: chatroom    
    func createNewChatRoom(roomType:String, nameRoom:String,memberJSONStr:String?,  callback: (Chatroom?, NSError?) -> ()){
        let url = getAbsoluteUrl("chatrooms/");
        var params = ["name": nameRoom,"chatroom_type":roomType]
        if(memberJSONStr != nil && countElements(memberJSONStr!) > 0){
            params.updateValue(memberJSONStr!, forKey: "members")

        }
        request(.POST, url, parameters: params).responseJSON({
            (request, response, data, error) in

            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var dicChat = objectResopnse as NSDictionary
//                    var jsonData = JSON(dataUser)
//                    var idUser = (jsonData["id"].stringValue).toInt()
                    var newChatRoom = Chatroom(aDictChat: dicChat)
//                    var newChatRoom = Chatroom(idRoom:idUser!, uuidRoom: jsonData["uuid"].stringValue)
                    callback(newChatRoom, error)
                }else{
                    callback(nil,nil)
                }
            })

            
            
        })
    }
    
    //rename
    func renameChatroom(roomID:Int, nameRoom:String,callback: (Bool?, NSError?) -> ()){
        let url = getAbsoluteUrl("chatrooms/") + String(roomID) + "/name"
        let params = ["name":nameRoom]
        
        request(.PATCH, url, parameters: params).responseJSON({
            (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                callback(isSuccess,error)
            })
            
        })
    }
    
    func updateChatRoomMembers(memberJSONStr:String, roomID:Int,callback: (Bool?, NSError?) -> ()){
        let url = getAbsoluteUrl("chatrooms/") + String(roomID) + "/members"
        let params = ["members":memberJSONStr]

        request(.POST, url, parameters: params).responseJSON({
            (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                callback(isSuccess,error)
            })
            
        })
    }
    
    //list chatroom
    func getListRoomsWithType(roomType:String?, userRoomID:Int?, params:[String:AnyObject], callback: (NSDictionary?, NSError?) -> ()){
        var url :String
        if(roomType == nil){
            //following
            if(userRoomID == nil){
                callback(nil,nil)
                return
            }
            url = getAbsoluteUrl("users/") + String(userRoomID!) + "/discover"
        }else{
            url = getAbsoluteUrl("chatrooms/") + roomType!

        }
        request(.GET, url  , parameters: params).responseJSON({
            (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){

                    if let dictionaryInfor = objectResopnse as? NSDictionary{
                        callback(dictionaryInfor, nil)
                    }else{
                        callback(nil, error)
                    }
                }else{
                    callback(nil,error)
                }
            })
        })
    }
    
    func getChatRoomInfor(chatroomID:Int,callback: (Chatroom?, NSError?) -> ()){
        var absoluteUrl = getAbsoluteUrl("chatrooms/") + String(chatroomID);
        let url = NSURL(string: absoluteUrl)
        
        request(.GET, url!).responseJSON({(request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var dataUser = objectResopnse as NSDictionary
                    if let newChatRoom = Chatroom(aDictChat: dataUser){
                        callback(newChatRoom, error)
                    }else{
                        callback(nil, error)
                    }
                }else{
                    callback(nil,nil)
                }
            })
            
        })
    }
    
    //find chatroom
    func getDiscoveryFromQueryUserName(params:[String: AnyObject],callback: (NSArray?, NSString?, NSError?) -> ()){
        let url = getAbsoluteUrl("search/discover");
        
        request(.GET, url  , parameters: params).responseJSON({
            (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    //
                    if let unwrappedData = objectResopnse as? NSArray{
                        callback(unwrappedData,nil,nil)
                    }else{
                        callback(nil, nil, nil)
                    }
                }else{
                    callback(nil, nil, nil)
                }
            })
        })
    }
    
    //flag post
    func flagingPost(chatroomID:Int, callBack:(Bool?, NSError?) -> ()){
        var params = ["type": "user"]

        let urlPost = getAbsoluteUrl("chatrooms/") + String(chatroomID) + "/flag"
        
        request(.POST, urlPost, parameters: nil).response { (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                callBack(isSuccess,error)
            })
        }
    }
    
    //rating love post
    func ratingPost(chatroomID:Int, isRating:Bool, callBack:(UInt64?, NSError?) -> ()){
        let params = ["item_id":NSNumber(integer: chatroomID),"type":"chatroom"]
        let urlPost = getAbsoluteUrl("ratings/float")
        if isRating == false{
            request(.POST, urlPost, parameters: params).response { (request, response, data, error) in
                self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                    if let newDepth = objectResopnse as? NSNumber{
                        callBack(newDepth.unsignedLongLongValue,error)
                    }else{
                        callBack(nil,error)
                    }

                })
            }
        }else{
            request(.DELETE, urlPost, parameters: params).response { (request, response, data, error) in
                self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                    if let newDepth = objectResopnse as? NSNumber{
                        callBack(newDepth.unsignedLongLongValue,error)
                    }else{
                        callBack(nil,error)
                    }
                })
            }
        }
    }
    
    //sink post
    func sinkPost(chatroomID:Int, isSink:Bool, callBack:(UInt64?, NSError?) -> ()){
        let params = ["item_id":NSNumber(integer: chatroomID),"type":"chatroom"]
        let urlPost = getAbsoluteUrl("ratings/sink")
        if isSink == false{
            request(.POST, urlPost, parameters: params).response { (request, response, data, error) in
                self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                    if let newDepth = objectResopnse as? NSNumber{
                        callBack(newDepth.unsignedLongLongValue,error)
                    }else{
                        callBack(nil,error)
                    }
                    
                })
            }
        }else{
            request(.DELETE, urlPost, parameters: params).response { (request, response, data, error) in
                self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                    if let newDepth = objectResopnse as? NSNumber{
                        callBack(newDepth.unsignedLongLongValue,error)
                    }else{
                        callBack(nil,error)
                    }
                })
            }
        }
    }

    //leave room
    func leaveRoom(chatroomID:Int, callBack:(Bool?, NSError?) -> ()){
        
        let urlPost = getAbsoluteUrl("chatrooms/") + String(chatroomID) + "/leave"
        
        request(.DELETE, urlPost, parameters: nil).response { (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                callBack(isSuccess,error)
            })
        }
    }
    
    //delete post 
    func deleteMyPost(chatroomID:Int, callBack:(Bool?, NSError?) -> ()){

        let urlPost = getAbsoluteUrl("chatrooms/") + String(chatroomID)

        request(.DELETE, urlPost, parameters: nil).response { (request, response, data, error) in
            self.handleCommonResponseWithData(data, error: error, callBack: { (objectResopnse, isSuccess) -> () in
                callBack(isSuccess,error)
            })
        }
    }
    
    //MARK: handling upload image user, message image
    func uploadImageAvatarToServer(typeImage:String, postData:NSData, callback: (String?,  NSError?) ->() ){
        self.uploadImageToServer("uploads/user", typeImage: typeImage, postData: postData, success: { (data, response) -> Void in
                var error: NSError?
                if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary!{
                    if let successAuthent = jsonDict["success"] as? Bool{
                        if successAuthent{
                            var urlString = jsonDict["data"] as String?
                            callback(urlString, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }else{
                        callback(nil, error)
                    }
                }
            })
            { (error) -> Void in
                callback(nil,error)
        }

    }

    func uploadImageChatToServer(typeImage:String, postData:NSData, callback: (String?,  NSError?) ->() ){
        self.uploadImageChatToServer(typeImage, postData: postData, isVideo:false, callback: callback)
    }
    
    func uploadImageChatToServer(typeImage:String, postData:NSData, isVideo:Bool, callback: (String?,  NSError?) ->() ){
        self.uploadImageToServer("uploads", typeImage: typeImage, postData: postData, isVideo:isVideo, success: { (data, response) -> Void in
            //parse nsdata to json
                var error: NSError?
                if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary!{
                    if let successAuthent = jsonDict["success"] as? Bool{
                        if successAuthent{
                            var urlString = jsonDict["data"] as String?
                            callback(urlString, nil)
                        }else{
                            callback(nil, nil)
                        }
                    }else{
                        callback(nil, error)
                    }
                }
            }) { (error) -> Void in
             callback(nil,error)
        }
    }
    
    func uploadUpdateExpressionImageUser(expressionType:String, postData:NSData, callback: (User?,  NSError?) ->() ){
        self.uploadImageToServer("uploads/user", typeImage: expressionType, postData: postData, success: { (data, response) -> Void in

            //parse nsdata to json
            var error: NSError?

            if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary!{
                if let successAuthent = jsonDict["success"] as? Bool{
                    if successAuthent{
                        var dictUser = jsonDict["data"] as NSDictionary!
                        var jsonUser = JSON(dictUser!)
                        User.shareInstance.setUser(jsonUser)
                        callback(User.shareInstance,nil)

                    }else{
                        callback(nil, nil)
                    }
                }else{
                    callback(nil, error)
                }
            }
            }) { (error) -> Void in
                callback(nil,error)
        }
    }
    
    func uploadImageToServer(urlPos:String, typeImage:String, postData:NSData?, success:SwifterHTTPRequest.SuccessHandler?, failure: SwifterHTTPRequest.FailureHandler? ){
        self.uploadImageToServer(urlPos, typeImage: typeImage, postData: postData, isVideo: false, success: success, failure: failure)
    }
    
    func uploadImageToServer(urlPos:String, typeImage:String, postData:NSData?, isVideo:Bool, success:SwifterHTTPRequest.SuccessHandler?, failure: SwifterHTTPRequest.FailureHandler? ){
        
        //using stwitter
        let url = NSURL(string:urlPos, relativeToURL:NSURL(string:BaseUrl))!
        var postDataKey: String?
        var method = "POST"
        var parameters: Dictionary<String, String> = ["type": typeImage]
        
        var request = SwifterHTTPRequest(URL: url, method:method, parameters: parameters,shouldHanleCookie:true)
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = NSUTF8StringEncoding
        request.encodeParameters = postData == nil
        
        if postData != nil {
            var fileName =  "media.jpg"
            if(isVideo){
                fileName = "media.mov"
            }

            request.addMultipartData(postData!, parameterName: "media", mimeType: "application/octet-stream", fileName: fileName)
        }
        
        request.start()      
    }
}
