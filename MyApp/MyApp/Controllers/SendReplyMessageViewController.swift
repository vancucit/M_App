//
//  SendReplyMessageViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/18/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
protocol SendReplyMessageControllerDelegate{
    func willReloadDataSource()
}
class SendReplyMessageViewController: BaseKeyboardViewController , UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightTopViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var txtViewContent: UIPlaceHolderTextView!
    @IBOutlet weak var btnCaptureCamera: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var imgContentMsg: UIImageView!
    
    var challengerID:String!
    var delegate:SendReplyMessageControllerDelegate?
    
    fileprivate var imagUpload:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtViewContent.placeholder = "Write a comment. Max 240 chracters."
        showImageMsg(false)

        self.setRightNavigationWithImage("ic_send", action: "sendChallengerTouched:")
        
    }

   //MARK: IBAction
    
    @IBAction func cameraTouched(_ sender: AnyObject) {
        showImagePickerForSourceType(UIImagePickerControllerSourceType.camera)

    }
    @IBAction func galleryTouched(_ sender: AnyObject) {

        showImagePickerForSourceType(UIImagePickerControllerSourceType.photoLibrary)

    }
    
    @IBAction func removeImageTouched(_ sender: AnyObject) {
        showImageMsg(false)
    }
    

    func showImageMsg(_ isShow:Bool){
        btnCaptureCamera.isHidden = isShow
        btnGallery.isHidden = isShow
        
        btnRemove.isHidden = !isShow
        imgContentMsg.isHidden = !isShow
        
        if isShow {
            heightTopViewConstraint.constant = 300
        }else{
            heightTopViewConstraint.constant = 160
        }

    }
    
   
    func sendChallengerTouched(_ sender:AnyObject!){
        if(imagUpload == nil){
            self.showDialog("", contentStr: "Missing value. Try again.")
            return
        }
        self.view.endEditing(true)
        self.showHudWithString("")
//        self.sendResponseWithUrl("http://url.com")
        
        AppRestClient.sharedInstance.uploadFileNew(imagUpload!, progress: { (percentage) -> () in
            print("------ \(percentage)")
            }, callback: { (urlImage, error) -> () in
                if(urlImage != nil){
                    self.sendResponseWithUrl(urlImage!)
                }else{
                    self.showDialog("Error", contentStr: "Upload failed. Try again.")
                    self.hideHudLoading()
                }
        })
 
    }
    func sendResponseWithUrl(_ attacmentUrl:String){
        
        AppRestClient.sharedInstance.sendReplyRepsone(challengerID, comment: txtViewContent.text, photoUrl: attacmentUrl, isResonse: true) { (success, error) -> () in
            if (success){
                if(self.delegate != nil){
                    self.delegate!.willReloadDataSource()
                }
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                self.showDialog("", contentStr: "Send response failured. ")
            }
            self.hideHudLoading()
        }
    }
    //MARK: Action sheet delegate
    
   
    func showImagePickerForSourceType(_ sourceType:UIImagePickerControllerSourceType){
        showImageMsg(true)
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
        imagUpload = info[UIImagePickerControllerEditedImage] as! UIImage
        imgContentMsg.image = imagUpload!
        
        //save to term directory
        let imageToSave:Data = UIImageJPEGRepresentation(imagUpload!, 0.7)!
        
        let path = NSTemporaryDirectory() + "temp_msg.jpeg"
        try? imageToSave.write(to: URL(fileURLWithPath: path), options: [.atomic])
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        showImageMsg(false)
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: keyboard
    override func keyboardWillChangeFrameWithNotification(_ notification: Foundation.Notification, showsKeyboard: Bool) {
        if(showsKeyboard){
            let userInfo = notification.userInfo!
            if let rectKB = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsetsMake(64, 0, rectKB.height, 0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
                var rect = txtViewContent.bounds
                rect = txtViewContent.convert(rect, to: scrollView)
                scrollView.scrollRectToVisible(rect, animated: true)
            }
        }else{
            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
            
            scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }

}
