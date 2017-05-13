
//
//  FollowTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
import SnapKit
class CompletedTableViewCell: UITableViewCell {

    var containResponseView: ResponseView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectionColor = UIView()
        selectionColor.backgroundColor = GlobalConstants.ColorConstant.DefaultSelectedColor
        self.selectedBackgroundView = selectionColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    func updateUI(){
        if(containResponseView == nil){
            if let aNewFeed = UIView.loadFromNibNamed("ResponseView") as? ResponseView{
                self.containResponseView = aNewFeed
                self.containResponseView.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        contentView.addSubview(self.containResponseView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containResponseView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(0)
            make.left.equalTo(contentView).offset(0)
            make.right.equalTo(contentView).offset(0)
            make.bottom.equalTo(contentView).offset(0)
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
