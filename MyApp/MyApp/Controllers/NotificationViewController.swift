//
//  NotificationViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var listNotification = [Notification]()
    var currentPageIndex = 0
    var hasMoreNotification = true
    var isLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showMenuButton()
        self.setTitleNavigationBar("Notification")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        delay(1.0, closure: { () -> () in
            self.retrieveData()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func resetData(){
        hasMoreNotification = true
        currentPageIndex = 0
        isLoading = false
    }
    func retrieveData(){
        if(isLoading){
            return
        }
        self.showHudWithString("")
        AppRestClient.sharedInstance.getNotifications(currentPageIndex, callback: { (notificationLoad, error) -> () in
            if(error == nil){
                if(notificationLoad != nil){
                    self.currentPageIndex += 1
                    self.listNotification += notificationLoad!
                    self.hasMoreNotification = notificationLoad!.count == AppRestClient.sharedInstance.Page_Notification
                    self.tableView.reloadData()
                }else{
                    self.hasMoreNotification = false
                }
            }else{
                self.showGeneralDialog()
            }
            self.hideHudLoading()
        })
        
    }

    //MARK - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCellID", for: indexPath) as! NotificationTableViewCell
        cell.notification = listNotification[indexPath.row]
        return cell
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotification.count;
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (isLoading == false && scrollView.isDragging == false && scrollView.isDecelerating == false){
            if(hasMoreNotification){
                if(scrollView.contentSize.height - scrollView.frame.size.height <= scrollView.contentOffset.y){
                    self.retrieveData()
                }
            }
        }
    }

}
