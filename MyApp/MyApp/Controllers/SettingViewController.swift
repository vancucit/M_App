//
//  SettingViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class SettingViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var listItem = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        var versionNameStr = "Version 1.0"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionNameStr = "Version " + version
        }
        listItem = [versionNameStr, "Help", "Send feedback", "Sign out"]
        self.showMenuButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 3:
            logOut()
            break
        default:
            self.showDialog("", contentStr: "Under construction")
            break
        }
    }
    func logOut(){
//        MyAppService.sharedInstance.client?.logout()
        User.logOut()
        FBSDKLoginManager().logOut()

        AuthToken.sharedInstance.logout()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLoginViewController()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCellID", for: indexPath) as! SettingTableViewCell
        cell.textLabel?.text = listItem[indexPath.row]
        return cell
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count;
    }

}
