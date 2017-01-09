//
//  SendMessageViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

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
    
    //picker timer
    let pickerTimer:[[String: String]] = [["1 hour":"OneHour"], ["2 hours":"TwoHours"], ["3 hours":"ThreeHours"], ["4 hours":"FourHours"], ["5 hours":"FiveHours"], ["10 hours":"TenHours"], ["15 hours":"FifteenHours"], ["20 hours":"TwentyHours"], ["1 day":"OneDays"], ["2 days":"TwoDays"], ["3 days":"TheeDays"], ["4 days":"FourDays"], ["5 days":"FiveDays"], ["6 days":"SixDays"], ["1 week":"OneWeek"], ["2 weeks":"TwoWeeks"], ["3 weeks":"ThreeWeeks"], ["1 month":"OneMonth"]]

    var pickerView:UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addPickerExpire()
        //create top view
        contactPicker = THContactPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 140))
        contactPicker.setPlaceholderString("Type contact name")
        contactPicker.delegate = self
        scrollView.addSubview(contactPicker)
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
    }
    func updateTableViewUserFrame(){
        tableViewUser.frame = CGRect(x: 0,y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - KeyBoarHeight - contactPicker.frame.size.height - 64)

    }
    func showChallengeNavigationBar(){
//        self.setRightNavigationWithImage("ic_send", action: "sendChallengerTouched:")
    }
    func showHiddenContactNavigatonBar(){

//        self.setRigtNavigationWithTitle("Done", action: "hiddenPickeTouched:")
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
            var endTime = ""
            for dictTime in pickerTimer {
                let keyStr = Array(dictTime.keys)[0]
                
                if keyStr == txtExpireValue.text {
                    endTime = dictTime[keyStr]!
                    break
                }
            }
//            forin
            self.showHudWithString("")
            AppRestClient.sharedInstance.sendChallenge("", description: txtViewContent.text, endDate: endTime, participants: userSelected, isPublic: switchPrivateChallenger.isSelected, callback: { (success, error) -> () in
                //
                if(success){
                    self.txtViewContent.text = ""
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showDialog("", contentStr: "Send challenge failed. Try again.")
                }
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
                    self.userFriends += userLoads!
                }
                self.tableViewUser.reloadData()
                
            }
            self.hideHudLoading()
        }
        
    }

   
    
    
    //MARK: - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var cell = tableViewUser.cellForRow(at: indexPath) as! THContactPickerTableViewCell
        var checkboxImageView = cell.viewWithTag(104) as! UIImageView

        var user = userFriends[indexPath.row]
        let indexUser = self.userSelected.index(of: user)
        if(indexUser == nil){
            contactPicker.addContact(user, withName: user.nameUser)
            checkboxImageView.image = UIImage(named: "icon-checkbox-selected-green-25x25")
            userSelected.append(user)

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
        var contactNameLabel = cell.viewWithTag(101) as! UILabel
        var contactImage = cell.viewWithTag(103) as! UIImageView
        var checkboxImageView = cell.viewWithTag(104) as! UIImageView
        
        var user = userFriends[indexPath.row]
        contactNameLabel.text = user.nameUser
        var userUrl = URL(string:user.avatar)
        contactImage.sd_setImage(with: userUrl, placeholderImage:  UIImage(named: "img_avatar_holder"))
        var indexUser = self.userSelected.index(of: user)
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
                var contentInsets = UIEdgeInsetsMake(64, 0, rectKB.height, 0)
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
extension SendMessageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: Picker Datasource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTimer.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var dicPick = pickerTimer[row]
//        return "test"
        return Array(dicPick.keys)[0]
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dicPick = pickerTimer[row]
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
