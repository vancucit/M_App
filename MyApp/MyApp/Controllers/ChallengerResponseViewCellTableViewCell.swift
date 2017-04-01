//
//  ChallengerResponseViewCellTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 2/24/17.
//  Copyright © 2017 Kuccu. All rights reserved.
//

import UIKit

class ChallengerResponseViewCellTableViewCell: UITableViewCell {
    var response:Response? {
        didSet{
            if responseView != nil {
                responseView.response = self.response
            }
        }
    }
    @IBOutlet weak var containResponseView: UIView!
    var responseView: ResponseView!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(responseView == nil){
            if let aNewFeed = UIView.loadFromNibNamed("ResponseView") as? ResponseView{
                self.responseView = aNewFeed
                self.responseView.translatesAutoresizingMaskIntoConstraints = false
                containResponseView.addSubview(self.responseView)
                self.responseView.originalBtn.isHidden = true
                
            }
        }
        
        containResponseView.layer.borderColor = UIColor.gray.cgColor
        containResponseView.layer.borderWidth = 1.0
        containResponseView.layer.cornerRadius = 2.0
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        self.selectedBackgroundView = backgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.responseView.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(self.containResponseView).offset(0)
            make.left.equalTo(self.containResponseView).offset(0)
            make.right.equalTo(self.containResponseView).offset(0)
            make.bottom.equalTo(self.containResponseView).offset(0)
        })
    }
}
