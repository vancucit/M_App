//
//  SegmentedControlTouched.swift
//  MyApp
//
//  Created by Cuc Nguyen on 5/5/17.
//  Copyright © 2017 Kuccu. All rights reserved.
//

import UIKit

class SegmentedControlTouched: UISegmentedControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.sendActions(for: .touchUpInside)

    }
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        
//        self.sendActions(for: .valueChanged)
//
//    }
}
