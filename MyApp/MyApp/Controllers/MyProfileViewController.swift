//
//  MyProfileViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class MyProfileViewController: BaseKeyboardViewController, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgAvatar: UIImageView!

    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtViewBio: UITextView!
    
    @IBOutlet weak var switchPublic: UISwitch!
    
    var isShowMenuHome = false
    
    var dataImageUpload:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //create save button 
        if(isShowMenuHome){
            self.showMenuButton()
        }else{
            self.setLeftNavigationWithTitle("Back", action: "closeTouched:")
        }
        self.setRigtNavigationWithTitle("Save", action: "saveProfile:")
        updateUI()
    }
    @IBAction func dissmissTaped(_ sender: AnyObject) {
        self.view.endEditing(true)
    }

    @IBAction func changeAvatarTaped(_ sender: AnyObject) {
        let actionSheet = UIActionSheet(title: NSLocalizedString("Choose action", comment: "Choose action photo"), delegate: self, cancelButtonTitle: NSLocalizedString("Cancel", comment: "CancelBtn"), destructiveButtonTitle:nil, otherButtonTitles: NSLocalizedString("UploadPhoto",comment: ""),NSLocalizedString("TakePhoto", comment: "TakePhoto btn") )
        actionSheet.show(in: view)

    }
    func updateUI(){
        let user = AuthToken.sharedInstance.currentUser
        txtUserName.text = user!.nameUser
        
        let userUrl = URL(string: user!.avatar)
        imgAvatar.sd_setImage(with: userUrl, placeholderImage: UIImage(named: "img_avatar_holder"))
        txtViewBio.text = user!.bio
        switchPublic.isSelected = user!.isPublic
//        if(user.isPubl)
    }
    
  
    func saveProfile(_ sender:AnyObject!){
        if(txtUserName.text!.characters.count == 0){
            self.showDialog("Validation", contentStr: "Name is required.")
        }else{
            self.showHudWithString("")
            self.view.endEditing(true)
            if(dataImageUpload != nil){
                let path = NSTemporaryDirectory() + "temp_avatar.jpeg"
                var urlFile = URL(fileURLWithPath: path)
                
                AppRestClient.sharedInstance.uploadFile(dataImageUpload!, progress: { (percentage) -> () in
                    print("------")
                }, callback: { (urlImage, error) -> () in
                    if(urlImage != nil){
                        self.savedProfile(urlImage!)
                    }else{
                        self.showDialog("Error", contentStr: "Upload failed. Try again.")
                        self.hideHudLoading()
                    }
                })
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
        var realAvatarUrl = avatarUrl
        if(avatarUrl == nil){
            realAvatarUrl = AuthToken.sharedInstance.currentUser?.avatar
        }
        var gender:String = ""
        var birthDate:String = ""
        AppRestClient.sharedInstance.updateProfile(txtUserName.text!, location: "", website: "", bio: txtViewBio.text, isPublic: switchPublic.isSelected, avatarUrl: avatarUrl, gender: "", birthday: "") { (success, error) -> () in
            if(success){
                AuthToken.sharedInstance.currentUser?.avatar = avatarUrl!
                AuthToken.sharedInstance.currentUser?.nameUser = self.txtUserName.text!
                AuthToken.sharedInstance.currentUser?.bio = self.txtViewBio.text
                AuthToken.sharedInstance.currentUser?.isPublic = self.switchPublic.isSelected
            }else{
                self.showDialog("Error", contentStr: "Update profile failed. Try again.")
            }
            self.hideHudLoading()
        }
    }

    //MARK: Action sheet delegate
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
            NSLog("cancle");
            break;
        case 1:
            showImagePickerForSourceType(UIImagePickerControllerSourceType.photoLibrary)
            NSLog("Photo");
            break;
        case 2:
            NSLog("Camera");
            showImagePickerForSourceType(UIImagePickerControllerSourceType.camera)
            
            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
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
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]){
        print("Helllo didFinishPickingMediaWithInfo")
        picker.dismiss(animated: true, completion: nil)
        dataImageUpload = info[UIImagePickerControllerEditedImage] as! UIImage
        imgAvatar.image = dataImageUpload
        
        //save to term directory 
        let imageToSave:Data = UIImagePNGRepresentation(dataImageUpload!)!
        
        let path = NSTemporaryDirectory() + "temp_avatar.jpeg"
        try? imageToSave.write(to: URL(fileURLWithPath: path), options: [.atomic])

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
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
