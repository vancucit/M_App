//
//  BaseViewController.swift
//  PipeFish
//
//  Created by Cuccku on 10/13/14.
//  Copyright (c) 2014 ImageSourceInc,. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var HUD: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.navigationController?.navigationBar.barTintColor = ConstantPipeFish.TintBarColor
        //        UINavigationBar.appearance().tintColor = ConstantPipeFish.TintBarColor
        //        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: ConstantPipeFish.TintBarColor]
        
        //        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont.systemFontOfSize(16)], forState: .Normal)
        
        //        UITextField.appearanceWhenContainedIn().UISe
        //        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blueColor]];
        
        
    }
    func showBackBtn(){
        let imageMenu = UIImage(named: "ic_back")
        let btnHome = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        btnHome.setImage(imageMenu, for: UIControlState())
        btnHome.addTarget(self, action: #selector(BaseViewController.backTouched(_:)), for: UIControlEvents.touchUpInside)
        let btnLeft = UIBarButtonItem(customView: btnHome)
        self.navigationItem.leftBarButtonItem = btnLeft;
    }
    func showMenuButton(){
        let imageMenu = UIImage(named: "ic_home")
        let btnHome = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        btnHome.setImage(imageMenu, for: UIControlState())
        btnHome.addTarget(self, action: #selector(BaseViewController.showHideMenu(_:)), for: UIControlEvents.touchUpInside)
        let btnLeft = UIBarButtonItem(customView: btnHome)
        self.navigationItem.leftBarButtonItem = btnLeft;
    }
    func showHideMenu(_ sender:AnyObject){
        self.view.endEditing(true)
        self.mm_drawerController.toggle(.left, animated: true, completion: { (success) in
            self.mm_drawerController.bouncePreview(for: .left, completion: nil)
        })
     
        
    }
    func backTouched(_ sender:AnyObject){
        let _ = self.navigationController?.popViewController(animated: true)
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showHudWithString(_ contentStr: String)-> (){
        DispatchQueue.main.async(execute: { () -> Void in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.HUD = MBProgressHUD(view: self.view)
            self.view.addSubview(self.HUD!)
            self.HUD?.labelText = NSLocalizedString(contentStr,comment: "")
            self.HUD?.show(true)
        })
    }
    
    func hideHudLoading()->(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        DispatchQueue.main.async(execute: { () -> Void in
            self.HUD?.hide(true)
            self.HUD?.removeFromSuperview()
            self.HUD = nil
        })
    }
    
    func showWaitingInTable(_ contentStr: String)-> (){
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = contentStr
    }
    
    func hideWaitingInTable()->(){
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        // beta5 workaround: replace nil with explicit name of xib file
        let nib = nibNameOrNil ?? "MyViewController"
        
        super.init(nibName: nib, bundle: nibBundleOrNil)
        
        // local initialization here
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTitleNavigationBar(_ titleStr:String){
        self.navigationItem.title = titleStr
    }
    func showHudLoadingInView(_ view:UIView){
        MBProgressHUD.showAdded(to: view, animated: true)
        
    }
    func hideHudLoadingInView(_ view:UIView){
        MBProgressHUD.hideAllHUDs(for: view, animated: true)
        
    }
    /*Used in WelcomeViewController, StartAppUpViewController*/
    func showPopup(_ title: String){
        showDialog("Pipe fish notification.", contentStr: title)
    }
    func showGeneralDialog(){
        var popUp = UIAlertController()
        popUp = UIAlertController(title: NSLocalizedString("GeneralErorTitle", comment: ""), message: NSLocalizedString("GeneralErrorMessage", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        popUp.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(popUp, animated: true, completion: nil)
    }
    func showDialogError(_ title: String?){
        if let titleDisplay = title {
            self.showDialog("mApp", contentStr: titleDisplay)
        }else{
            self.showGeneralDialog()
        }
        
    }
    func showDialogOnConstruction(){
        var popUp = UIAlertController()
        popUp = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("API on construction!", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        popUp.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(popUp, animated: true, completion: nil)
    }
    func showDialog(_ title: String,contentStr:String){
        var popUp = UIAlertController()
        popUp = UIAlertController(title: title, message: contentStr, preferredStyle: UIAlertControllerStyle.alert)
        popUp.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(popUp, animated: true, completion: nil)
    }
    func setLeftNavigationWithTitle(_ aTitle:String, action:Selector){
        let leftBarBtn = UIBarButtonItem(title: aTitle, style: .done, target: self, action: action)
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    func setRigtNavigationWithTitle(_ aTitle:String, action:Selector){
        let rightBarBtn = UIBarButtonItem(title: aTitle, style: .done, target: self, action: action)
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    func setLeftNavigationWithImage(_ imageName:String, action:Selector){
        let leftBarBtn = UIBarButtonItem(image: UIImage(named: imageName), style: UIBarButtonItemStyle.done, target: self, action: action)
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    func setRightNavigationWithImage(_ imageName:String, action:Selector){
        let imageMenu = UIImage(named: imageName)
        let btnHome = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
        btnHome.setImage(imageMenu, for: UIControlState())
        btnHome.addTarget(self, action: action, for: UIControlEvents.touchUpInside)
        btnHome.contentMode = .center
        let barBtn = UIBarButtonItem(customView: btnHome)

        self.navigationItem.rightBarButtonItem = barBtn
    }
}
