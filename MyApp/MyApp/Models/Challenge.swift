//
//  Challenge.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/20/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class Challenge: NSObject {
    var idChallenge: String!
    var attachment:String?
    var descriptionChallenge:String?
    var likeCount:Int = 0
    var dislikeCount:Int = 0
    var dateCreate:Date?
    var endDate:Date?
    var commentCount = 0
    var user:User?
    var participants = [User]()
    var isLikeByCurrentUser = false
    var isDislikeByCurrentUser = false
    var isSentToCurrentUser = false
    var hasResponseByCurrentUser = false
    var isRateByCurrentUser = false
    var totalRatedPoint = 0
    var ratedByCurrentUser = 0
    var challengeReceivedID:String?

    convenience init(jsonDict:NSDictionary) {
        self.init()
        
        idChallenge = jsonDict["id"] as! String
        attachment = jsonDict["Attachment"] as? String
        descriptionChallenge = jsonDict["Description"] as? String
        likeCount = jsonDict["LikeCount"] as! Int
        dislikeCount = jsonDict["DislikeCount"] as! Int
        commentCount = jsonDict["CommentCount"] as! Int
        if let dicUser = jsonDict["User"] as? NSDictionary{
            user = User(jsonDict: dicUser)
        }
        if let participiantUser = jsonDict["Participants"] as? [NSDictionary]{
            for dicAUser in participiantUser {
                participants.append(User(jsonDict: dicAUser))
            }
        }

        let dateCreateStr = jsonDict["DateCreated"] as! String
        dateCreate = dateWithISO8601String(dateCreateStr)
        if let dateEndStr = jsonDict["EndDate"] as? String{
            endDate = dateWithISO8601String(dateEndStr)
        }
        
        isLikeByCurrentUser = jsonDict["IsLikeByCurrentUser"] as! Bool
        if let aBoolValue = jsonDict["IsDislikeByCurrentUser"] as? Bool {
            isDislikeByCurrentUser = aBoolValue
        }
        if let aBoolValue = jsonDict["IsSentToCurrentUser"] as? Bool {
            isSentToCurrentUser = aBoolValue
        }
//        isSentToCurrentUser = jsonDict["IsSentToCurrentUser"] as! Bool
        if let aBoolValue = jsonDict["HasResponseByCurrentUser"] as? Bool {
            hasResponseByCurrentUser = aBoolValue
        }
//        hasResponseByCurrentUser = jsonDict["HasResponseByCurrentUser"] as! Bool
        if let aBoolValue = jsonDict["IsRatedByCurrentUser"] as? Bool {
            isRateByCurrentUser = aBoolValue
        }
//        isRateByCurrentUser = jsonDict["IsRatedByCurrentUser"] as! Bool
        
        totalRatedPoint = jsonDict["TotalRatedPoint"] as! Int
        ratedByCurrentUser = jsonDict["RatedByCurrentUser"] as! Int
        challengeReceivedID = jsonDict["ChallengeReceiverId"] as? String
    }
}
