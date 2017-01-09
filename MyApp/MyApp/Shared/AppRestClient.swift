//
//  MyAppRestClient.swift
//  MyApp
//
//  Created by Cuccku on 10/20/14.
//  Copyright (c) 2014 ImageSourceInc,. All rights reserved.
//

import UIKit
import Alamofire

//http://vmobileapi.southeastasia.cloudapp.azure.com/#/docs
let BaseHost = "vmobileapi.southeastasia.cloudapp.azure.com"
let BaseUrl = "http://" + BaseHost + "/"


enum KeyTypeStr:String{
    case KeyTypeFaceBook = "facebook",KeyTypeTwitter = "twitter",KeyTypeGoogle = "google",KeyTypeMicrosoft = "microsoft"
}

class AppRestClient {

    let findPeoplePageSize = 15
    let Page_Count = 15
    let Page_Notification = 10
    
    class var sharedInstance : AppRestClient {
        struct Static {
            static let instance : AppRestClient = AppRestClient()
        }
        return Static.instance
    }
      func  getAbsoluteUrl(_ relativeUrl: String) -> String{
        print("test \(BaseUrl + relativeUrl)")
        return BaseUrl + relativeUrl
    }
    
    func handleCommonResponseWithDataDetail(_ result:Result<Any>, isNeedShowDialog:Bool, callBack:(Any?,Bool)->())->(){
        switch result {
            case .success(let aData):
                //            print(aData)
                if let stringData = aData as? String{
                    var errorParse:NSError?
                    
                    var dataResponse: Data = stringData.data(using: String.Encoding.utf8)!
                    let json: AnyObject?
                    do {
                        json = try JSONSerialization.jsonObject(with: dataResponse, options: JSONSerialization.ReadingOptions.allowFragments) as? AnyObject
                        
                    } catch let error as NSError {
                        errorParse = error
                        json = nil
                    }
                    
                    if let unwrappedData = json as? NSDictionary {
                        if let successAuthent = unwrappedData["Success"] as? Bool{
                            let dataDict = unwrappedData["Data"] as AnyObject
                            callBack(dataDict, successAuthent)
                        }else{
                            callBack(errorParse?.description, false)
                        }
                        
                    }
                }else if let unwrappedData = aData as? NSDictionary {
                    if let errorStr = unwrappedData["message"] as? String{
                        //failure
                        callBack(errorStr, false)
                    }else{
                        callBack(unwrappedData, true)
                    }
//                    if let successAuthent = unwrappedData["Success"] as? Bool{
//                        let dataDict = unwrappedData["Data"] as AnyObject
//                        callBack(dataDict, successAuthent)
//                    }else{
//                        callBack(unwrappedData["Data"] as AnyObject, false, nil)
//                        print("Failure reason \(unwrappedData)")
//                    }
                }else if let dataResponse = aData as? Data{
                    var errorParse:NSError?
                    
                    let json: AnyObject?
                    do {
                        json = try JSONSerialization.jsonObject(with: dataResponse, options: JSONSerialization.ReadingOptions.allowFragments) as? AnyObject
                        
                    } catch let error as NSError {
                        errorParse = error
                        json = nil
                    }
                    
                    if let unwrappedData = json as? NSDictionary {
                        if let errorStr = unwrappedData["message"] as? String{
                            //failure
                            callBack(errorStr, false)
                        }else{
                            callBack(unwrappedData, true)
                        }
                        
                    }else{
                        callBack(nil, false)
                    }
                }else if let arrayData = aData as? [Any]{
                    
                    callBack(arrayData, true)
                    
                }else{
                    print("Failure reason : nil response")
                    
                    callBack(nil, false)
                }
                break
            case .failure(let error):
                if(isNeedShowDialog == true){
                    self.showGeneralDialog(isNeedShowDialog)
                }
                callBack(error.localizedDescription, false)
            break
        }
        
    }
    func  showGeneralDialog(_ isNeedShowDialog:Bool)  {
        if isNeedShowDialog {
            let alertView = UIAlertView(title: "Error", message: NSLocalizedString("general_issue_message", comment: "general_issue_message"), delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    func handleCommonResponseWithData(_ aData:DataResponse<Any>,  callBack:(Any?,Bool)->())->(){
        let dataResult = aData.result
        self.handleCommonResponseWithDataDetail(dataResult, isNeedShowDialog:false, callBack: callBack)
    }
    
//    func uploadTest(){
//        var url = "http://nurolink-staging.azurewebsites.net/api/upload?code=A4905952-A7B6-4016-B84F-6F95571FFEAC"
//    }
//    func uploadTest(dataImage:UIImage, progress:(CGFloat?) ->(), callback:(String?,NSError?) -> () ){
//        // CREATE AND SEND REQUEST ----------
//        
//        
//        //        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
//        
//        var parameters = ["file":NetData(jpegImage: dataImage, compressionQuanlity: 0.7, filename: "avatar12.jpg")]
//        
//
//        var url = "http://nurolink-staging.azurewebsites.net/api/upload?code=A4905952-A7B6-4016-B84F-6F95571FFEAC"
//        let urlRequest = self.urlRequestWithComponents(url, parameters: parameters)
//        Alamofire.upload(urlRequest)
//            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
//                print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
//            }
//            .responseJSON { (request, response, JSON, error) in
//                self.handleCommonResponseWithData(JSON, error: error, callBack: { (objectResopnse, isSuccess) -> () in
//                    if(isSuccess == true){
//                        var urlUpload = objectResopnse as! String
//                        callback(urlUpload, nil)
//                    }else{
//                        callback(nil,error)
//                    }
//                })
//        }
//    }
    //
       
    func addAuthToken(_ authToken:String){
        // Creating an Instance of the Alamofire Manager
        var xHTTPAdditionalHeaders: [AnyHashable: Any] = ["Authorization": "Bearer " + authToken]
//        Alamofire.
//        var manager = Alamofire.Manager.sharedInstance
        // Specifying the Headers we need
//        manager.session.configuration.HTTPAdditionalHeaders = xHTTPAdditionalHeaders
//        Alamofire.Manager.sharedInstance.session.configuration.httpAdditionalHeaders = xHTTPAdditionalHeaders

    }
    func getFollows(_ userID:String, page:Int, keyword:String,getFollowing:Bool, callback:@escaping ([User]?,String?)->()){
        var urlRequest = getFollowing ? getAbsoluteUrl("user/followings"):getAbsoluteUrl("user/followers")
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let params = ["pageIndex": page as AnyObject,"limit":Page_Count as AnyObject,"userId":userID as AnyObject, "keyword":keyword as AnyObject] as [String:AnyObject]

        request(urlRequest, method:.post, parameters: params).responseJSON(){ result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
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
    
    func getPendingFollowers(_ pageIndex:Int, keyword:String,callback:@escaping ([User]?,String?)->()){
        let urlRequest = getAbsoluteUrl("user/followers/pending")
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let params = ["pageIndex": pageIndex as AnyObject,"limit":Page_Count as AnyObject, "keyword":keyword as AnyObject] as [String:AnyObject]
        
        request(urlRequest, method:.post, parameters: params).responseJSON(){ result in
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
    
    func follow(_ userID:String, isFollow:Bool, callback:@escaping (Bool, String?)->()){
        var urlRequest = isFollow ? getAbsoluteUrl("user/follow/request/") + userID :getAbsoluteUrl("user/unfollow/") + userID
        request(urlRequest, method:.get, parameters: nil).responseJSON(){ result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                callback(isSuccess,objectResopnse as? String)
            })
        }
    }
   
    
    //MARK: Challenger
    func sendChallenge(_ attacmentUrl:String,description:String,endDate:String,participants:[User], isPublic:Bool, callback:@escaping (Bool,String?)->()){
        var isPublicStr = "false"
        if(isPublic){
            isPublicStr = "true"
        }
        var arrayIDUser = [Dictionary<String,String>]()
        for user in participants {
            arrayIDUser.append(["ID":user.idUser])
        }

        let params = ["Description": description as AnyObject,"ExpirationType":endDate as AnyObject,"IsPublic": isPublic as AnyObject, "Participants":arrayIDUser as AnyObject]  as [String:AnyObject]
        
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)

        Alamofire.request(getAbsoluteUrl("challenge/send"),method:.post, parameters: params).responseJSON(){ result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true, nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
    }
   
    func getNewFeed(_ pageIndex:Int, newFeedType:NewsType, keyword:String, callback:@escaping ([NewFeed]?,String?) -> ()){
        var urlCall:String!
        switch newFeedType {
        case .NewChallenger:
            urlCall = "challenges/to-me"
            break
            
        case .Following:
            urlCall = "news/following"
            break
        case .Public:
            urlCall = "news/public"
            break
        default:
            callback(nil,nil)
            return
        }
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let params = ["pageIndex": pageIndex as AnyObject,"limit":Page_Count as AnyObject, "keyword":keyword as AnyObject] as [String:AnyObject]
        
        request(getAbsoluteUrl(urlCall), method:.post, parameters: params).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var arrUser = objectResopnse as! [NSDictionary]
                    var challengers = [NewFeed]()
                    for dictUser  in arrUser{
                        if(newFeedType == NewsType.NewChallenger){
                            var challenge = NewFeed(challenge: Challenge(jsonDict: dictUser))
                            challengers.append(challenge)
                        }else{
                            var newFeed = NewFeed(response: Response(jsonDict: dictUser))
                            challengers.append(newFeed)
                        }
                    }
                    callback(challengers, nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }

    }
  
    
    func getResponse(_ pageIndex:Int, userId:String, callback:@escaping ([Response]?,String?) -> ()){
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let params = ["pageIndex": pageIndex as AnyObject,"limit":Page_Count as AnyObject, "userId":userId as AnyObject] as [String:AnyObject]
        
        request( getAbsoluteUrl("responses"), method:.post, parameters: params).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var arrUser = objectResopnse as! [NSDictionary]
                    var responses = [Response]()
                    for dictUser  in arrUser{
                        var response = Response(jsonDict: dictUser)
                        responses.append(response)
                    }
                    callback(responses, nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    
    
    func rejectChallenger(_ idChallenge:String, callback:@escaping (Bool,String?) -> ()){
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        var urlRequest = getAbsoluteUrl("challenge/reject/") + idChallenge
        request(urlRequest, method:.get, parameters: nil).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true,nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
    }
    func likeChallenger(_ itemID:String, challengerID:String, callback:@escaping (Bool,String?) -> ()){
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let urlRequest = getAbsoluteUrl("challenge/like/") + itemID + "/" + challengerID
        request( urlRequest + challengerID, method:.get, parameters: nil).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true,nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
    }
    func getVotersForChallenge(_ challengerID:String, page:Int, isLike:Bool, callback:@escaping ([User]?, String?) ->() ){
        let urlRequest = getAbsoluteUrl("challenge/voters")
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        
        var likeStr = "false"
        if(isLike){
            likeStr = "true"
        }
        let params = ["pageIndex": page as AnyObject,"limit":Page_Count as AnyObject,"challengeId":challengerID as AnyObject, "like":likeStr as AnyObject] as [String:AnyObject]
        
        request(urlRequest, method:.post, parameters: params).responseJSON(){
            result in
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
    //MARK: Response
    func likeResponse(_ isLike:Bool, responseID:String, callback:@escaping (Bool,String?) -> ()){
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let urlRequest = (isLike) ? getAbsoluteUrl("response/like/") : getAbsoluteUrl("response/dislike/")
        request(urlRequest + responseID,method:.get, parameters: nil).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true,nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
    }
    func sendResponse(_ challengeID:String, comment:String, photoUrl:String, isResonse:Bool, callback:@escaping (String?, String?) -> ()){
        
        let params = ["ChallengeID": challengeID as AnyObject,"Photo":photoUrl as AnyObject,"Comment": comment as AnyObject, "IsResponse":isResonse as AnyObject]  as [String:AnyObject]
        
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        
        Alamofire.request(getAbsoluteUrl("response"),method:.post,  parameters: params).responseJSON(){
            result in
            
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(objectResopnse as? String,nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    func commentResponse(_ responseID:String, comment:String, callback:@escaping (String?, String?) -> ()){
        
        let params = ["ResponseID": responseID as AnyObject,"Comment": comment as AnyObject]  as [String:AnyObject]
        
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        
        Alamofire.request(getAbsoluteUrl("response/comment"), method:.post, parameters: params).responseJSON(){
            result in
            
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(objectResopnse as? String, nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    func getCommentsForResponse(_ responseID:String, pageIndex:Int, callback:@escaping ([ResponseComment]?,String?) ->()){
        
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let params = ["pageIndex": pageIndex as AnyObject,"limit":Page_Count as AnyObject, "responseId":responseID as AnyObject] as [String:AnyObject]

        request(getAbsoluteUrl("response/comments"),method:.post,  parameters: params).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var arrDict = objectResopnse as! [NSDictionary]
                    var responses = [ResponseComment]()
                    for dicComment  in arrDict{
                        var newComment = ResponseComment(objDic: dicComment)
                        responses.append(newComment)
                    }
                    callback(responses, nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    
    func getResponsesForChallenge(_ challengeID:String, pageIndex:Int, callback: @escaping ([Response]?,String?) -> () ){
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let params = ["pageIndex": pageIndex as AnyObject,"limit":Page_Count as AnyObject, "challengeId":challengeID as AnyObject] as [String:AnyObject]
        
        request(getAbsoluteUrl("responses/challenge"), method:.post, parameters: params).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    let arrDict = objectResopnse as! [NSDictionary]
                    var responses = [Response]()
                    for dicComment  in arrDict{
                        let newComment = Response(jsonDict: dicComment)
                        responses.append(newComment)
                    }
                    callback(responses, nil)
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    func getVotersForResponse(_ responseID:String, page:Int, isLike:Bool, callback:@escaping ([User]?, String?) ->() ){
        let urlRequest = getAbsoluteUrl("response/voters")
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        var likeStr = "false"
        if(isLike){
            likeStr = "true"
        }
        let params = ["pageIndex": page as AnyObject,"limit":Page_Count as AnyObject,"responseId":responseID as AnyObject, "like":likeStr as AnyObject] as [String:AnyObject]
        
        request(urlRequest, method:.post, parameters: params).responseJSON(){
            result in
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
    func rateResponse(_ responseID:String, rate:Int, callback:@escaping (Bool, String?) -> ()){
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let params = ["responseId": responseID as AnyObject,"rate":rate as AnyObject] as [String:AnyObject]

        let urlRequest = getAbsoluteUrl("response/rate")
        request(urlRequest, method:.post , parameters: params).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true,nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
    }
    func rateChallenge(_ challengeAuthorID:String, challengeID:String, rate:Int, callback:@escaping (Bool, String?) -> ()){
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        let params = ["challengeAuthorID": challengeAuthorID as AnyObject,"challengeID":challengeID as AnyObject,"rate":rate as AnyObject] as [String:AnyObject]
        var urlRequest = getAbsoluteUrl("challenge/rate")
        request(urlRequest ,method:.post, parameters: params).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    callback(true,nil)
                }else{
                    callback(false,objectResopnse as? String)
                }
            })
        }
    }

    //MARK: Notification
    func getNotifications(_ pageIndex:Int , callback:@escaping ([Notification]?, String?)->()){

        let params = ["pageIndex":pageIndex as AnyObject,"limit":Page_Notification as AnyObject] as [String:AnyObject]
        request(getAbsoluteUrl("notifications"), method:.post, parameters: params).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    var arrDict = objectResopnse as! [NSDictionary]
                    var notifications = [Notification]()
                    for aDict  in arrDict{
                        var notification = Notification(aDictMessage: aDict)
                        notifications.append(notification!)
                    }
                    callback(notifications, nil)
                }else{
                 callback(nil,objectResopnse as? String)
                }
            })
        }
        

    }
    func getBadgeCount(_ callback: @escaping (BadgeCount?, String?) -> ()) {
        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)
        request(getAbsoluteUrl("user/badge"),method:.get, parameters: nil).responseJSON(){
            result in
            self.handleCommonResponseWithData(result, callBack: { (objectResopnse, isSuccess) -> () in
                if(isSuccess == true){
                    if let badegeCount = BadgeCount(jsonDict: (objectResopnse as! NSDictionary)){
                        callback(badegeCount, nil)

                    }
                }else{
                    callback(nil,objectResopnse as? String)
                }
            })
        }
    }
    //MARK:  Upload file
    func uploadFile(_ dataImage:UIImage, progress:(CGFloat?) ->(), callback:(String?,String?) -> () ){
        // CREATE AND SEND REQUEST ----------
        

        self.addAuthToken(AuthToken.sharedInstance.authenticationToken!)

        let parameters = ["file":NetData(jpegImage: dataImage, compressionQuanlity: 0.7, filename: "avatar1.jpg")]
        
        
        let urlRequest = self.urlRequestWithComponents(getAbsoluteUrl("upload"), parameters: parameters as NSDictionary)
        
        
//        Alamofire.upload(urlRequest)
//            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
//                print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
//            }
//            .responseJSON { (request, response, JSON, error) in
//                self.handleCommonResponseWithData(JSON, error: error, callBack: { (objectResopnse, isSuccess) -> () in
//                    if(isSuccess == true){
//                        var urlUpload = objectResopnse as! String
//                        callback(urlUpload, nil)
//                    }else{
//                        callback(nil,error)
//                    }
//                })
//        }
    }
    
    
    func urlRequestWithComponents(_ urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, Data) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(url: URL(string: urlString)!)
        mutableURLRequest.httpMethod = "POST"
        //let boundaryConstant = "myRandomBoundary12345"
        let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add parameters
        for (key, value) in parameters {
            
            uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            
            if value is NetData {
                // add image
                var postData = value as! NetData
                
                
                //uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                
                // append content disposition
                var filenameClause = " filename=\"\(postData.filename)\""
                let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
                let contentDispositionData = contentDispositionString.data(using: String.Encoding.utf8)
                uploadData.append(contentDispositionData!)
                
                
                // append content type
                //uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
                let contentTypeString = "Content-Type: \(postData.mimeType.getString()!)\r\n\r\n"
                let contentTypeData = contentTypeString.data(using: String.Encoding.utf8)
                uploadData.append(contentTypeData!)
                uploadData.append(postData.data)
                
            }else{
                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
            }
        }
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        
//        let encodedURLRequest = ParameterEncoding.URL.encode(mutableURLRequest, parameters).0

        // return URLRequestConvertible and NSData
        return (mutableURLRequest as! URLRequestConvertible, uploadData as Data)
//        return (Alamofire.ParameterEncoding.url.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }

    
}
