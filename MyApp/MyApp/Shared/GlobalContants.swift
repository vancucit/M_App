//
//  GlobalContant.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/30/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

struct GlobalConstants {
    struct ColorConstant {
        static let DefaultSelectedColor = UIColor(red: 51/255.0, green: 181.0/255, blue: 229.0/255.0, alpha: 1)
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
        static let Tmp = NSTemporaryDirectory()
    }
}
