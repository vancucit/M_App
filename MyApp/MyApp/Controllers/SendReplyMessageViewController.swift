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
class SendReplyMessageViewController: BaseKeyboardViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightTopViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var txtViewContent: UIPlaceHolderTextView!
    @IBOutlet weak var btnCaptureCamera: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var imgContentMsg: UIImageView!
    
    var challengerID:String!
    var delegate:SendReplyMessageControllerDelegate?
    var uploadImageURL:String?
    
    fileprivate var imagUpload:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtViewContent.placeholder = "Write a comment. Max 240 chracters."
        showImageMsg(false)

        self.setRightNavigationWithImage("ic_send", action: #selector(SendReplyMessageViewController.sendChallengerTouched(_:)))
        
        self.animateButton()
    }
    
    func animateButton(){
        
        
        self.btnGallery.alpha = 1.0
        self.btnGallery.transform =
            CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        self.btnCaptureCamera.alpha = 0.6
        self.btnCaptureCamera.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.repeat, .autoreverse, .curveEaseOut, .allowUserInteraction], animations: {
            //
            self.btnGallery.alpha = 0.6
            self.btnGallery.transform =
                CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            self.btnCaptureCamera.alpha = 1.0
            self.btnCaptureCamera.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }) { (success) in

        }
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
            
            self.btnGallery.layer.removeAllAnimations()
            self.btnCaptureCamera.layer.removeAllAnimations()
        }else{
            heightTopViewConstraint.constant = 160
            DispatchQueue.main.async(execute: { () -> Void in
                self.animateButton()
            })
        }

    }
    
   
    func sendChallengerTouched(_ sender:AnyObject!){
        if(imagUpload == nil){
            self.showDialog("", contentStr: "Missing value. Try again.")
            return
        }
        
        self.view.endEditing(true)
        self.showHudWithString("")
        if uploadImageURL != nil {
            self.sendResponseWithUrl(uploadImageURL!)
        }else{
            AppRestClient.sharedInstance.uploadFileNew(imagUpload!, progress: { (percentage) -> () in
                print("------ \(percentage)")
            }, callback: { (urlImage, error) -> () in
                if(urlImage != nil){
                    self.uploadImageURL = urlImage
                    self.sendResponseWithUrl(urlImage!)
                }else{
                    self.showDialog("Error", contentStr: "Upload failed. Try again.")
                    self.hideHudLoading()
                }
            })
        }
        
    }
    func sendResponseWithUrl(_ attacmentUrl:String){
        
        AppRestClient.sharedInstance.sendReplyRepsone(challengerID, comment: txtViewContent.text, photoUrl: attacmentUrl, isResonse: true) { (success, error) -> () in
            self.hideHudLoading()

            if (success){
                if(self.delegate != nil){
                    self.delegate!.willReloadDataSource()
                }
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                self.showDialog("", contentStr: "Send response failured. ")
            }
        }
    }
    
   
    func showImagePickerForSourceType(_ sourceType:UIImagePickerControllerSourceType){
        showImageMsg(true)
        let theImagePickerController = UIImagePickerController()
        theImagePickerController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        theImagePickerController.sourceType = sourceType
        theImagePickerController.delegate = self
        theImagePickerController.allowsEditing = true
        self.navigationController?.present(theImagePickerController, animated: true, completion: nil)
        
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
extension SendReplyMessageViewController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        print("Helllo didFinishPickingMediaWithInfo")
        picker.dismiss(animated: true, completion: nil)
        guard let imagUploadForce = info[UIImagePickerControllerEditedImage] as? UIImage else{
            print("image nill")
            return
        }
        self.imagUpload = imagUploadForce
        imgContentMsg.image = imagUploadForce
        
        //save to term directory
        let imageToSave:Data = UIImageJPEGRepresentation(imagUploadForce, 0.7)!
        
        let path = NSTemporaryDirectory() + "temp_msg.jpeg"
        try? imageToSave.write(to: URL(fileURLWithPath: path), options: [.atomic])
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        self.dismiss(animated: true) {
            self.showImageMsg(false)

        }
        
    }
    

}
