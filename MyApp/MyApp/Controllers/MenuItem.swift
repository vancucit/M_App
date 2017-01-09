//
//  MenuItem.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/16/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

open class MenuItem :NSObject{
    var title: String!
    var notificationNum: String!
    var imageURL: String!

    override init(){
        super.init()
    }
    convenience init(title: String, imageURL: String, notificationNum: String)  {
        self.init()
        self.title = title
        self.notificationNum = notificationNum
        self.imageURL = imageURL
    }
}

