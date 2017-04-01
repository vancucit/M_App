
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
        idComment = String(objDic["id"] as! Int)
        commentContent = objDic["comment"] as! String
        if let dateCreateStr = objDic["createDate"] as? String{
            postedOn = dateWithISO8601String(dateCreateStr)
        }else{
            postedOn = Date()
        }
        
        
        
        if let dicUser = objDic["user"] as? NSDictionary{
            user = User(jsonDict: dicUser)
        }

    }
}
