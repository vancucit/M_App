//
//  BaseKeyboardViewController.swift
//  PipeFish
//
//  Created by Cuc Nguyen on 1/22/15.
//  Copyright (c) 2015 CloudZilla. All rights reserved.
//

import UIKit

class BaseKeyboardViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNotification()
    }

    func registerNotification() -> (){
        
        NotificationCenter.default.addObserver(self, selector:#selector(BaseKeyboardViewController.handleKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(BaseKeyboardViewController.handleKeyboardWillHideNotification(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func handleKeyboardWillShowNotification(_ notification: Foundation.Notification){
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
        
    }
    func handleKeyboardWillHideNotification(_ notification: Foundation.Notification){
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
        
    }
    func keyboardWillChangeFrameWithNotification(_ notification: Foundation.Notification, showsKeyboard: Bool) {
        fatalError("should ovverride keyboardWillChangeFrameWithNotification")
    }
}
