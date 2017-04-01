//
//  LeftMenuTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgViewSquareIcon: UIImageView!
    
    @IBOutlet weak var lblNumNotif: UILabel!
    
    
    var menuItem:MenuItem! {
        didSet{
            imgViewIcon.image = UIImage(named: menuItem.imageURL)
            imgViewIcon.contentMode = .scaleAspectFill
            lblTitle.text = menuItem.title
            if(menuItem.notificationNum.characters.count <= 0){
                imgViewSquareIcon.isHidden = true
                lblNumNotif.isHidden = true
            }else{
                imgViewSquareIcon.isHidden = false
                lblNumNotif.isHidden = false
                lblNumNotif.text = menuItem.notificationNum
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectionColor = UIView()

        selectionColor.backgroundColor = GlobalConstants.ColorConstant.DefaultSelectedColor
        self.selectedBackgroundView = selectionColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
