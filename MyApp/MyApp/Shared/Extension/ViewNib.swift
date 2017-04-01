//
//  ViewNib.swift
//  PipeFish
//
//  Created by Cuccku on 11/4/14.
//  Copyright (c) 2014 CloudZilla. All rights reserved.
//

import Foundation
import QuartzCore
extension UIView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: self, options: nil)[0] as? UIView
    }
    func cornerButton(){
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
}
