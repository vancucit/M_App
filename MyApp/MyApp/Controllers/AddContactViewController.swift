//
//  AddContactViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 5/13/17.
//  Copyright © 2017 Kuccu. All rights reserved.
//

import UIKit

class AddContactViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    static func storyboardInstance() -> AddContactViewController? {
        let storyboard = UIStoryboard(name: "AddContactViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? AddContactViewController
    }
}
