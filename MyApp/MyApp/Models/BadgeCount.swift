//
//  BadgeCount.swift
//  MyApp
//
//  Created by Cuc Nguyen on 6/25/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class BadgeCount: NSObject {
    
    fileprivate var _followers:Int = 0
    fileprivate var _following:Int = 0
    fileprivate var _notifications:Int = 0

    //get
    func getFollower() -> Int {
        return _followers
    }
    func getFllowing() -> Int{
        return _following
    }
    func getNotification() -> Int{
        return _notifications
    }
    
    convenience init ?(jsonDict:NSDictionary?){
        self.init()
        if(jsonDict != nil){
            _followers = jsonDict!["Followers"] as! Int
            _following = jsonDict!["Following"] as! Int
            _notifications = jsonDict!["Notifications"] as! Int
        }else{
            return nil
        }

    }

}
