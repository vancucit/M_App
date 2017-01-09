
//
//  ResponseComment.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/30/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class ResponseComment: NSObject {
    var idComment:String!
    var commentContent:String!
    var postedOn:Date!
    var user:User?
    
    convenience init(objDic:NSDictionary){
        self.init()
        idComment = objDic["id"] as! String
        commentContent = objDic["Comment"] as! String
        let dateCreateStr = objDic["DateCreated"] as! String
        
        postedOn = dateWithISO8601String(dateCreateStr)
        
        if let dicUser = objDic["User"] as? NSDictionary{
            user = User(jsonDict: dicUser)
        }

    }
}
