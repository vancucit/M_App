//
//  Challenge.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/20/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

struct ChallengerParticipant {
    var idChaPart:String
    var isAccepted:Bool = false
    var isCreator: Bool = false
    var challengerID:String
    init(jsonDict:NSDictionary) {
        idChaPart = String(jsonDict["id"] as! Int)
        isAccepted = (jsonDict["accept"] as? Bool)!
        isCreator = (jsonDict["creator"] as? Bool)!
        challengerID = String(jsonDict["challengeId"] as! Int)
    }
}

class Challenge: NSObject {
    var idChallenge: String!
    var attachment:String?
    var descriptionChallenge:String?
    var likeCount:Int = 0
    var dislikeCount:Int = 0
    var dateCreate:Date?
    var endDate:Date?
    var commentCount = 0
    var numberResponse:Int = 0
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
        idChallenge = String(jsonDict["id"] as! Int)
        descriptionChallenge = jsonDict["description"] as? String
        attachment = jsonDict["attachment"] as? String
        commentCount = jsonDict["commentCount"] as! Int
        numberResponse = jsonDict["responseCount"] as! Int

        if let participiantUser = jsonDict["challengeParticipants"] as? [NSDictionary]{
            for dicAUser in participiantUser {
                let challengerPartic = ChallengerParticipant(jsonDict: dicAUser)
                if challengerPartic.isCreator {
                    self.user = User(jsonDict: (dicAUser["user"] as! NSDictionary))
                }else{
                    let aUser  = User(jsonDict: (dicAUser["user"] as! NSDictionary))
                    participants.append(aUser)
                }
            }
        }
        if let dateCreateStr = jsonDict["createDate"] as? String{
            dateCreate = dateWithISO8601String(dateCreateStr)
        }
        if let dateEndStr = jsonDict["endDate"] as? String{
            endDate = dateWithISO8601String(dateEndStr)
        }
        isLikeByCurrentUser = jsonDict["like"] as! Bool

        /*


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

        if let aBoolValue = jsonDict["HasResponseByCurrentUser"] as? Bool {
            hasResponseByCurrentUser = aBoolValue
        }
        if let aBoolValue = jsonDict["IsRatedByCurrentUser"] as? Bool {
            isRateByCurrentUser = aBoolValue
        }

        
        totalRatedPoint = jsonDict["TotalRatedPoint"] as! Int
        ratedByCurrentUser = jsonDict["RatedByCurrentUser"] as! Int
        challengeReceivedID = jsonDict["ChallengeReceiverId"] as? String
 */
        
    }
}
