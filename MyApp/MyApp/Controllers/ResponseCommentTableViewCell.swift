//
//  ResponseCommentTableViewCell.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/30/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class ResponseCommentTableViewCell: UITableViewCell {
    var responseComment:ResponseComment!{
        didSet{
            self.textLabel?.text = responseComment.commentContent
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
