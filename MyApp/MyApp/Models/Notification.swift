//
//  Notification.swift
//  PipeFish
//
//  Created by mac on 11/21/14.
//  Copyright (c) 2014 CloudZilla. All rights reserved.
//


import UIKit

class Notification: NSObject {
    let TYPE_FOLLOW = "Follow"
    let TYPE_FOLLOW_REQUEST = "FollowRequest"
    let TYPE_FOLLOW_IGNORE = "FollowIgnore"
    let TYPE_UNFOLLOW = "UnFollow"
    let TYPE_FOLLOW_ACCEPT = "FollowAccept"
    let TYPE_REQUEST = "Request"
    let TYPE_RESPONSE = "Response"
    let TYPE_RESPONSE_FOR_FOLLOWING = "ResponseForFollowing"
    let TYPE_REJECT_CHALLENGE = "RejectChallenge"
    let TYPE_LIKE_REQUEST = "LikeRequest"
    let TYPE_LIKE_RESPONSE = "LikeResponse"
    let TYPE_RATE_REQUEST = "RateRequest"
    let TYPE_RATE_RESPONSE = "RateResponse"
    
    var idNotif:String!
    var objectNoti:AnyObject?
    var typeNoti:String = ""
    var markAsRead:Bool = false
    var messageStr:String!
    var createdBy:User!
    var extraData:String?
    
    
    convenience init?(aDictMessage: NSDictionary){
        self.init()
        idNotif = aDictMessage["id"] as! String
        typeNoti = aDictMessage["Type"] as! String
        markAsRead = aDictMessage["MarkAsRead"] as! Bool
        let dicUser = aDictMessage["CreatedByUser"] as! NSDictionary
        createdBy = User(jsonDict: dicUser)
        extraData = aDictMessage["ExtraData"] as? String
        switch typeNoti{
            case TYPE_FOLLOW, TYPE_FOLLOW_REQUEST,TYPE_FOLLOW_IGNORE,TYPE_UNFOLLOW,TYPE_FOLLOW_ACCEPT,TYPE_REJECT_CHALLENGE:
                objectNoti = User(jsonDict: aDictMessage["Item"] as! NSDictionary)
                break
            case TYPE_REQUEST, TYPE_LIKE_REQUEST, TYPE_RATE_REQUEST:
                print("Challenge enter here")
                if let dicUser = aDictMessage["Item"] as? NSDictionary{
                    objectNoti = Challenge(jsonDict: dicUser)
                }
                break
                
            case TYPE_RESPONSE:
                print("")
            case TYPE_RESPONSE_FOR_FOLLOWING:
                print("")
            case TYPE_LIKE_RESPONSE:
                print("")
            case TYPE_RATE_RESPONSE:
                objectNoti = Challenge(jsonDict: aDictMessage["Item"] as! NSDictionary)
            default:
                print("Default")
                break
        }
    }
    
    func getMessage() -> String{
    
        switch typeNoti{
            
            case TYPE_FOLLOW:
                return "Started following you."
            case TYPE_FOLLOW_REQUEST:
                return "Sent you a follow request."
            case TYPE_FOLLOW_IGNORE:
                return "Ignored your follow request."
            case TYPE_UNFOLLOW:
                return "Has unfollowed you."
            case TYPE_FOLLOW_ACCEPT:
                return "Accepted your follow request."
            case TYPE_REJECT_CHALLENGE:
                return "Reject your request."
            case TYPE_REQUEST:
                return "Sent you a challenge request."
            case TYPE_LIKE_REQUEST:
                return "Like your request."
            case TYPE_RATE_REQUEST:
                return "Rate your request \(extraData!) points."
            case TYPE_RESPONSE:
                return "Like your response."
            case TYPE_RESPONSE_FOR_FOLLOWING:
                return "Sent \(extraData!) a response."
            case TYPE_LIKE_RESPONSE:
                return "Like your response."
            case TYPE_RATE_RESPONSE:
                return "Rate your response \(extraData!) points."

            default:
                print("Default")
                break
        }

        return ""
    }
}
