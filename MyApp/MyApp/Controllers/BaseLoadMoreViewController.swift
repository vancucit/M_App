//
//  BaseLoadMoreViewController.swift
//  DealARide
//
//  Created by Cuc Nguyen on 4/6/16.
//  Copyright © 2016 CloudZilla. All rights reserved.
//

import UIKit

class BaseLoadMoreViewController: BaseViewController {
    var loadingMoreFootView:UIView?
    var isLoading = false
    var pageNumber:Int = 1
    var isCanLoadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLoading = false
        self.isCanLoadMore = true
        // Do any additional setup after loading the view.
    }

    func getLoadMoreView() -> UIView {
        if(loadingMoreFootView == nil){
            loadingMoreFootView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
            let activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 10, width: self.view.bounds.size.width, height: 50)) as UIActivityIndicatorView
            activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            activityView.hidesWhenStopped = false
            activityView.startAnimating()
            loadingMoreFootView?.addSubview(activityView)
        }
        return loadingMoreFootView!
    }
    func hideLoadMoreView(){
        self.isLoading = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if(self.loadingMoreFootView != nil){
            self.loadingMoreFootView?.removeFromSuperview()
            self.loadingMoreFootView = nil
        }
    }

}
