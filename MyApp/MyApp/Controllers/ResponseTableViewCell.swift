//
//  ResponseTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 5/4/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class ResponseTableViewCell: UITableViewCell {


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var contentResponseView: UIView!

    @IBOutlet weak var containResponseView: UIView!
    @IBOutlet weak var containChallengeView: UIView!
    
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var heightChallengeConstant: NSLayoutConstraint!
    @IBOutlet weak var heightResponseConstraint: NSLayoutConstraint!
    
    var challengeView: ChallengeView!
    var responseView: ResponseView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectionColor = UIView()
        selectionColor.backgroundColor = GlobalConstants.ColorConstant.DefaultSelectedColor
        self.selectedBackgroundView = selectionColor
        /*
        containChallengeView.layer.borderColor = UIColor.gray.cgColor
        containChallengeView.layer.borderWidth = 1.0
        containChallengeView.layer.cornerRadius = 1.0
        containChallengeView.clipsToBounds = true
        */
        
        containResponseView.layer.borderColor = UIColor.gray.cgColor
        containResponseView.layer.borderWidth = 1.0
        containResponseView.layer.cornerRadius = 1.0
        containResponseView.clipsToBounds = true

    }
    func addCommonUI(){
        if(responseView == nil){
            if let aNewFeed = UIView.loadFromNibNamed("ResponseView") as? ResponseView{
                self.responseView = aNewFeed
                self.responseView.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        self.containResponseView.addSubview(self.responseView)

        print("heightResponseConstraint.constant: \(heightResponseConstraint.constant)")
        if (challengeView == nil){
            if let aChallengeView = UIView.loadFromNibNamed("ChallengeView") as? ChallengeView{
                self.challengeView = aChallengeView
            
                self.challengeView.translatesAutoresizingMaskIntoConstraints = false
                
            }
        }
        self.containChallengeView.addSubview(self.challengeView)
    }
    func updateUI(){
        heightResponseConstraint.constant = responseView.heightOfResponseView()
        heightChallengeConstant.constant = challengeView.heightContraintChallengerView()

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.responseView.snp.makeConstraints { (make) in
            make.top.equalTo(self.containResponseView).offset(0)
            make.left.equalTo(self.containResponseView).offset(0)
            make.right.equalTo(self.containResponseView).offset(0)
            make.bottom.equalTo(self.containResponseView).offset(0)
        }
//        self.responseView.snp_makeConstraints({ (make) -> Void in
//            make.top.equalTo(self.containResponseView).offset(0)
//            make.left.equalTo(self.containResponseView).offset(0)
//            make.right.equalTo(self.containResponseView).offset(0)
//            make.bottom.equalTo(self.containResponseView).offset(0)
//        })
        self.challengeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.containChallengeView).offset(0)
            make.left.equalTo(self.containChallengeView).offset(0)
            make.right.equalTo(self.containChallengeView).offset(0)
            make.bottom.equalTo(self.containChallengeView).offset(0)

        }
//        self.challengeView.snp_makeConstraints({ (make) -> Void in
//            make.top.equalTo(self.containChallengeView).offset(0)
//            make.left.equalTo(self.containChallengeView).offset(0)
//            make.right.equalTo(self.containChallengeView).offset(0)
//            make.bottom.equalTo(self.containChallengeView).offset(0)
//        })
 
    }

}
