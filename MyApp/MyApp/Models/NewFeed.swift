//
//  NewFeed.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/28/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class NewFeed: NSObject {
    let Type_Response = "response"
    let Type_Challenge = "challenge"
    
    fileprivate var _type :String!
    fileprivate var _item :AnyObject!
    
    convenience init(objDic:NSDictionary){
        self.init()
        _type = (objDic["Type"]! as AnyObject).string
        if _type == Type_Response {
            _item = Response(jsonDict: (objDic["Item"] as! NSDictionary))
        }else{
            _item = Challenge(jsonDict: (objDic["Item"] as! NSDictionary))
        }
    }
    
    convenience init(challenge:Challenge){
        self.init()
        _type = Type_Challenge
        _item = challenge
    }
    convenience init(response:Response){
        self.init()
        _type = Type_Response
        _item = response
    }
    
    func getType() -> String {
        return _type
    }
    func getItem() -> AnyObject{
        return _item
    }
}
