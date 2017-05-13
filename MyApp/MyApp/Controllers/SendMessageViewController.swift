//
//  SendMessageViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

let TIME_DAY: Int = 24
protocol SendMessageDelegate :NSObjectProtocol{
    func didSendNewMessage()
}
class SendMessageViewController: BaseKeyboardViewController, UITableViewDelegate, UITableViewDataSource , UITextViewDelegate{
    let KeyBoarHeight:CGFloat = 216
    @IBOutlet weak var txtExpireValue: UITextField!
    @IBOutlet weak var txtViewContent: UIPlaceHolderTextView!
    @IBOutlet weak var switchPrivateChallenger: UISwitch!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    var tableViewUser:UITableView!
    var contactPicker:THContactPickerView!
    
    var userFriends = [User]()
    var userSelected = [User]()
    var friendPageIndex = 0
    var hasMoreFriends = true
    var imageSend:UIImage?
    
    weak var delegate:SendMessageDelegate?
    
    //picker timer
    let pickerTimer:[[String: Int]] = [["1 hour":1], ["2 hours":2], ["3 hours":3], ["4 hours":4], ["5 hours":5], ["10 hours":10], ["15 hours":15], ["20 hours":20], ["1 day":TIME_DAY], ["2 days":TIME_DAY*2], ["3 days":TIME_DAY*3], ["4 days":TIME_DAY*4], ["5 days":TIME_DAY*5], ["6 days":TIME_DAY * 6], ["1 week":TIME_DAY * 7], ["2 weeks": TIME_DAY * 7 * 2], ["3 weeks":TIME_DAY * 7 * 3], ["1 month":TIME_DAY * 30]]

    var pickerView:UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addPickerExpire()
        //create top view
        contactPicker = THContactPickerView(frame: CGRect(x: 10, y: 0, width: self.view.frame.size.width - 20, height: 140))
        contactPicker.setPlaceholderString("Type contact name")
        contactPicker.delegate = self
        self.topView.addSubview(contactPicker)
        scrollView.delegate = self
        
        txtViewContent.delegate = self
        //TableView user 
        tableViewUser = UITableView(frame: CGRect(x: 0, y: contactPicker.frame.origin.y + contactPicker.frame.size.height + 64, width: self.view.frame.size.width, height: self.view.frame.size.height - KeyBoarHeight - contactPicker.frame.size.height - 64))

        tableViewUser.delegate = self;
        tableViewUser.dataSource = self;
        tableViewUser.register(UINib(nibName: "THContactPickerTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactCell")


        
        self.view.insertSubview(tableViewUser, belowSubview: contactPicker)
        tableViewUser.isHidden = true
        self.getListFriends()

        txtViewContent.placeholder = "Challenger description . Max 240 chars"
        showChallengeNavigationBar()
        
        for user in self.userSelected {
            self.addContactToPicker(user)
        }
    }
    func updateTableViewUserFrame(){
        tableViewUser.frame = CGRect(x: 0,y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - KeyBoarHeight - contactPicker.frame.size.height)

    }
    func showChallengeNavigationBar(){
        self.setRightNavigationWithImage("ic_send_36pt", action: #selector(SendMessageViewController.sendChallengerTouched(_:)))
    }
    func showHiddenContactNavigatonBar(){

        self.setRigtNavigationWithTitle("Done", action: #selector(SendMessageViewController.hiddenPickeTouched(_:)))
    }
    //MARK: IBAaction
    func hiddenPickeTouched(_ sender:AnyObject!){
        self.tableViewUser.isHidden = true
        self.view.endEditing(true)
        showChallengeNavigationBar()
    }
    func sendChallengerTouched(_ sender:AnyObject!){
        
        if(userSelected.count == 0 || txtViewContent.text.isEmpty){
            self.showDialog("", contentStr: "Missing value. Try again.")
            return
        }
        self.view.endEditing(true)
        if(imageSend != nil){
            
        }else{
            var endTime: Int = 1
            for dictTime in pickerTimer {
                let keyStr = Array(dictTime.keys)[0]
                
                if keyStr == txtExpireValue.text {
                    endTime = dictTime[keyStr]!
                    break
                }
            }
//            forin
            self.showHudWithString("")
            weak var thisSelf = self
            AppRestClient.sharedInstance.sendChallenge("", descriptionStr: txtViewContent.text, endDate: endTime, participants: userSelected, isPublic: !switchPrivateChallenger.isOn, callback: { (success, error) -> () in
                //
                DispatchQueue.main.async(execute: {
                    if(success){
                        thisSelf?.delegate?.didSendNewMessage()
                        thisSelf?.txtViewContent.text = ""
                        thisSelf?.navigationController?.popViewController(animated: true)
                        
                    }else{
                        thisSelf?.showDialog("", contentStr: "Send challenge failed. Try again.")
                    }
                })
              
                self.hideHudLoading()
            })
        }
    }
    
    func getListFriends(){
        //TODO: remove later
//        return
        if(!hasMoreFriends){
            return
        }
        self.showHudWithString("")
        
        AppRestClient.sharedInstance.getListUsers(friendPageIndex, keyword: "") { (userLoads, error) -> () in
            if(error == nil){
                if(userLoads != nil){
                    self.friendPageIndex += 1
                    self.hasMoreFriends = userLoads!.count == AppRestClient.sharedInstance.Page_Count
                    for aUser in userLoads! {
                        if User.shareInstance.idUser != aUser.idUser {
                            if let currentSelectedUser = self.hasExistSelectedUser(userID: aUser.idUser){
                                self.userFriends.append(currentSelectedUser)
                            }else{
                                self.userFriends.append(aUser)
                            }
                        }
                        
                    }
                }
                self.tableViewUser.reloadData()
                
            }
            self.hideHudLoading()
        }
        
    }

    func hasExistSelectedUser(userID:String) -> User? {
      
        for aUser in self.userSelected {
            if aUser.idUser == userID {
                return aUser
            }
        }
        return nil
    }
    func addContactToPicker(_ user:User){
        contactPicker.addContact(user, withName: user.nameUser)
        userSelected.append(user)

    }
    
    //MARK: - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableViewUser.cellForRow(at: indexPath) as! THContactPickerTableViewCell
        let checkboxImageView = cell.viewWithTag(104) as! UIImageView

        let user = userFriends[indexPath.row]
        
        let indexUser = self.userSelected.index(of: user)
        if(indexUser == nil){
            self.addContactToPicker(user)
            checkboxImageView.image = UIImage(named: "icon-checkbox-selected-green-25x25")


        }else{
            self.userSelected.removeObject(object: user)
            checkboxImageView.image = UIImage(named: "icon-checkbox-unselected-25x25")
            self.contactPicker.removeContact(user)
            //add
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! THContactPickerTableViewCell
        
        // Get the UI elements in the cell;
        let contactNameLabel = cell.viewWithTag(101) as! UILabel
        let contactImage = cell.viewWithTag(103) as! UIImageView
        let checkboxImageView = cell.viewWithTag(104) as! UIImageView
        
        let user = userFriends[indexPath.row]
        contactNameLabel.text = user.nameUser
        
        if let userStr = user.getThumnailAvatar() {
            contactImage.sd_setImage(with: URL(string: userStr), placeholderImage: UIImage(named: "img_avatar_holder"))
            
        }else{
            contactImage.image = UIImage(named: "img_avatar_holder")
        }
        
        let indexUser = self.userSelected.index(of: user)
        if(indexUser != nil){
            checkboxImageView.image = UIImage(named: "icon-checkbox-selected-green-25x25")
        }else{
            checkboxImageView.image = UIImage(named: "icon-checkbox-unselected-25x25")

        }
        return cell
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFriends.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(scrollView == tableViewUser){
//            self.view.endEditing(true)
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if (scrollView.dragging == false && scrollView.decelerating == false){
//            if(scrollView.contentSize.height - scrollView.frame.size.height - 24 <= scrollView.contentOffset.y){
//            
//            }
//        }
        

        if velocity.y < -1.0 {
            print("bottom")
            self.view.endEditing(true)
            txtExpireValue.endEditing(true)
            showChallengeNavigationBar()

        }
    }
    //MARK: TextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView){
        var rect = textView.bounds
        rect = textView.convert(rect, to: scrollView)
        rect.origin.x = 0
        rect.origin.y = rect.origin.y - CGFloat(60.0)
        rect.size.height = 400
//        scrollView.scrollRectToVisible(rect, animated: true)

    }


    
    func addPickerExpire(){
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        txtExpireValue.inputView = pickerView
    }
   
    //MARK: keyboard 
    override func keyboardWillChangeFrameWithNotification(_ notification: Foundation.Notification, showsKeyboard: Bool) {
        if(showsKeyboard){
            let userInfo = notification.userInfo!
            if let rectKB = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsetsMake(0, 0, rectKB.height, 0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
                var rect = txtViewContent.bounds
                rect = txtViewContent.convert(rect, to: scrollView)
                
                scrollView.scrollRectToVisible(rect, animated: true)
            }
        }else{
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            
            scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }
}
extension SendMessageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: Picker Datasource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTimer.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dicPick = pickerTimer[row]
//        return "test"
        return Array(dicPick.keys)[0]
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dicPick = pickerTimer[row]
        txtExpireValue.text = Array(dicPick.keys)[0]
    }

}

extension SendMessageViewController: THContactPickerDelegate {
 //MARK: picker deleage
    func contactPickerTextViewDidChange(_ textViewText: String!) {
        //
    }
    func contactPickerDidDidBeginEditing(_ textView: UITextView!) {
        tableViewUser.isHidden = false
        showHiddenContactNavigatonBar()

    }
    func contactPickerDidEndEditing(_ textView: UITextView!) {
        tableViewUser.isHidden = true
//        showChallengeNavigationBar()
    }
    
    func contactPickerDidRemoveContact(_ contact: Any!) {
        let userRemove = contact as! User
        
        let indexRow = self.userFriends.index(of: userRemove)
        let cell = tableViewUser.cellForRow(at: IndexPath(row: indexRow!, section: 0)) as! THContactPickerTableViewCell
        let checkboxImageView = cell.viewWithTag(104) as! UIImageView
        checkboxImageView.image = UIImage(named: "icon-checkbox-unselected-25x25")
        
        self.userSelected.removeObject(object: userRemove)
        
    }
    
    func contactPickerDidResize(_ contactPickerView: THContactPickerView!) {
        //
        self.updateTableViewUserFrame()
        
    }
}
