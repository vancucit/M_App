//
//  Response.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/20/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class Response: NSObject {
    var idResponse: String!
    var photoUrl:String?
    var comment:String?

    var likeCount:Int = 0
//    var dislikeCount:Int = 0
    var commentCount = 0
    
    var postedOn:Date?


    var user:User?

    var isLikeByCurrentUser = false
    var isDislikeByCurrentUser = false
    
    var isRate = false
    var isResponse = false
    var rate = 0

    var challengerID:String?
    var challenger:Challenge?
    
    convenience init(jsonDict:NSDictionary) {
        self.init()
        
        idResponse = String(jsonDict["id"] as! Int)
        photoUrl = jsonDict["photo"] as? String
        comment = jsonDict["comment"] as? String
        
        likeCount = jsonDict["likeCount"] as! Int
//        dislikeCount = jsonDict["DislikeCount"] as! Int
        commentCount = jsonDict["commentCount"] as! Int
        
        if let dicUser = jsonDict["user"] as? NSDictionary{
            user = User(jsonDict: dicUser)
        }

        
        let dateCreateStr = jsonDict["createDate"] as! String
        postedOn = dateWithISO8601String(dateCreateStr)
        if let challngerInt = jsonDict["challengeId"] as? Int {
            challengerID = String(challngerInt)
        }
        isLikeByCurrentUser = jsonDict["like"] as! Bool

//
//        isLikeByCurrentUser = jsonDict["IsLikeByCurrentUser"] as! Bool
//        if let aBoolValue = jsonDict["IsDislikeByCurrentUser"] as? Bool {
//            isDislikeByCurrentUser = aBoolValue
//        }
//        isResponse = jsonDict["IsResponse"] as! Bool
//        isRate =  jsonDict["IsRated"] as! Bool
//        rate = jsonDict["Rate"] as! Int
        if let challengerDic = jsonDict["challenge"] as? NSDictionary{
            challenger = Challenge(jsonDict: challengerDic )
        }

    }

}
