//
//  Configuration.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class Configuration: NSObject {
    var azureMobileServiceApplicationURL:String!
    var azureMobileServiceApplicationKey:String!
    override init(){
        super.init()
    }
    convenience init(jsonDict:NSDictionary){
        self.init()
        azureMobileServiceApplicationURL = jsonDict["AzureMobileServiceApplicationURL"] as! String
        azureMobileServiceApplicationKey = jsonDict["AzureMobileServiceApplicationKey"] as! String
    }
}
