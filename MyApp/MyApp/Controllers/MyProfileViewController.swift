//
//  MyProfileViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class MyProfileViewController: BaseKeyboardViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgAvatar: UIImageView!

    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtViewBio: UITextView!
    
    @IBOutlet weak var switchPublic: UISwitch!
    
    @IBOutlet weak var segmenedUser: SegmentedControlTouched!
    
    var isShowMenuHome = false
    
    var dataImageUpload:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //create save button 
        if(isShowMenuHome){
            self.showMenuButton()
        }else{
            self.setLeftNavigationWithTitle("Back", action: #selector(MyProfileViewController.closeTouched(_:)))
        }
        self.setRigtNavigationWithTitle("Save", action: #selector(MyProfileViewController.saveProfile(_:)))
        updateUI()
        self.setTitleNavigationBar("My Profile")
        
        
//        txtViewBio
        
        txtViewBio.layer.borderColor = UIColor.gray.cgColor
        txtViewBio.layer.borderWidth = 1.0
        txtViewBio.layer.cornerRadius = 3.0
        txtViewBio.clipsToBounds = true
        self.showHudWithString("")
        AppRestClient.sharedInstance.checkAuthentication(User.getToken()!, callback: { (sucess, error) -> () in
            self.hideHudLoading()
            if (sucess){
                self.updateUI()
            }else{
                User.logOut()
            }
        })
    }
    @IBAction func dissmissTaped(_ sender: AnyObject) {
        self.view.endEditing(true)
    }

    @IBAction func changeAvatarTaped(_ sender: AnyObject) {
        
        let params = Parameters(
            title:  NSLocalizedString("Choose action", comment: ""),
            message: "",
            cancelButton: "Cancel",
            otherButtons: [NSLocalizedString("UploadPhoto",comment: ""), NSLocalizedString("TakePhoto", comment: "")]
        )
    
        
        AlertHelper().showAlertWithHandler(self, parameters: params) { buttonIndex in
            switch buttonIndex {
            case 0:
                print("Cancel: \(buttonIndex)")
            case 1:
                self.showImagePickerForSourceType(UIImagePickerControllerSourceType.photoLibrary)
                NSLog("Photo");
                break;
            case 2:
                NSLog("Camera");
                self.showImagePickerForSourceType(UIImagePickerControllerSourceType.camera)
                
                break;
            default:
                NSLog("Default");
                break;
            }
        }

    }
    func updateUI(){
        let user = User.shareInstance
        txtUserName.text = user.nameUser
        
        if let userAvatarStr = user.getAvatarUrl() {
            let userUrl = URL(string: userAvatarStr)
            imgAvatar.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
        }
        
        txtViewBio.text = user.bio
        switchPublic.isSelected = user.isPublic
        updateTitleFollow()
//        if(user.isPubl)
    }
    
    func updateTitleFollow(){
        let user = User.shareInstance

        var followingStr = " following"
        if(user.followingCount > 1){
            followingStr = " followings"
        }
        var followerStr = " follower"
        if(user.followerCount > 1){
            followerStr = " followers"
        }
        segmenedUser.setTitle(String(user.followerCount) + followerStr, forSegmentAt: 0)
        segmenedUser.setTitle(String(user.followingCount) + followingStr, forSegmentAt: 1)
        
    }
    func saveProfile(_ sender:AnyObject!){
        if(txtUserName.text!.characters.count == 0){
            self.showDialog("Validation", contentStr: "Name is required.")
        }else{
            self.showHudWithString("")
            self.view.endEditing(true)
            if(dataImageUpload != nil){
                AppRestClient.sharedInstance.uploadFileNew(dataImageUpload!, progress: { (percentage) -> () in
                }, callback: { (urlImage, error) -> () in
                    if(urlImage != nil){
                        self.savedProfile(urlImage!)
                    }else{
                        self.showDialog("Error", contentStr: "Upload failed. Try again.")
                        self.hideHudLoading()
                    }
                })
                
//                AppRestClient.sharedInstance.uploadFile(dataImageUpload!, progress: { (percentage) -> () in
//                    print("------")
//                }, callback: { (urlImage, error) -> () in
//                    if(urlImage != nil){
//                        self.savedProfile(urlImage!)
//                    }else{
//                        self.showDialog("Error", contentStr: "Upload failed. Try again.")
//                        self.hideHudLoading()
//                    }
//                })
            }else{
                self.savedProfile(nil)
            }
        }
    }
    func uploadImageAvatar(_ gotImage:UIImage) {
        imgAvatar.image = gotImage
    }

    func closeTouched(_ sender:AnyObject!){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func swtchPublicChange(_ sender: AnyObject) {
    }
    func savedProfile(_ avatarUrl:String?){

        AppRestClient.sharedInstance.updateProfile(txtViewBio.text, avatarUrl: avatarUrl) { (success, error) -> () in
            if(success){
                if avatarUrl != nil {
                    User.shareInstance.avatar = avatarUrl!    
                }
                
                User.shareInstance.nameUser = self.txtUserName.text!
                User.shareInstance.bio = self.txtViewBio.text
                User.shareInstance.isPublic = self.switchPublic.isSelected
                self.updateUI()
            }else{
                self.showDialog("Error", contentStr: "Update profile failed. Try again.")
            }
            self.hideHudLoading()
        }
    }

  
    func showImagePickerForSourceType(_ sourceType:UIImagePickerControllerSourceType){
        let theImagePickerController = UIImagePickerController()
        theImagePickerController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        theImagePickerController.sourceType = sourceType
        theImagePickerController.delegate = self
        theImagePickerController.allowsEditing = true
        self.navigationController?.present(theImagePickerController, animated: true, completion: nil)
            
    }
    
    @IBAction func segnmentValueChanged(_ sender: Any) {
        guard let segment = sender as? UISegmentedControl else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let followVC = storyboard.instantiateViewController(withIdentifier: "FollowViewControllerID") as! FollowViewController;
        
        if segment.selectedSegmentIndex == 0 {
            followVC.typeFollow = TypeFollowStr.FollwerType
            
        }else{
            followVC.typeFollow = TypeFollowStr.FollowingType
        }
        self.navigationController?.pushViewController(followVC, animated: true)
    }
    //MARK: UIImagePickerControllerDelegate

  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        print("Helllo didFinishPickingMediaWithInfo")
        picker.dismiss(animated: true, completion: nil)
        guard let aDataImageUpload = info[UIImagePickerControllerEditedImage] as? UIImage else{
            return
        }
        self.dataImageUpload = aDataImageUpload
        imgAvatar.image = dataImageUpload
        
        //save to term directory
        let imageToSave:Data = UIImagePNGRepresentation(aDataImageUpload)!
        
        let path = NSTemporaryDirectory() + "temp_avatar.jpeg"
        try? imageToSave.write(to: URL(fileURLWithPath: path), options: [.atomic])
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)

    }

    
    @IBAction func segmendTouched(_ sender: Any) {
        guard let segment = sender as? UISegmentedControl else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let followVC = storyboard.instantiateViewController(withIdentifier: "FollowViewControllerID") as! FollowViewController

        if segment.selectedSegmentIndex == 0 {
            followVC.typeFollow = TypeFollowStr.FollwerType
            
        }else{
            followVC.typeFollow = TypeFollowStr.FollowingType
        }
        self.navigationController?.pushViewController(followVC, animated: true)
    }
    //MARK - keyboard
    override func keyboardWillChangeFrameWithNotification(_ notification: Foundation.Notification, showsKeyboard: Bool) {
        if(showsKeyboard){
            let userInfo = notification.userInfo!
            if let rectKB = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsetsMake(0, 0, rectKB.height, 0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets

            }
        }else{
            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }


}
