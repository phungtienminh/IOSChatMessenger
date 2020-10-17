//
//  MessageCell.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/30/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    //imgAvatar
    @IBOutlet weak var leadingImgConstraint: NSLayoutConstraint!
    @IBOutlet weak var altTrailingImgConstraint: NSLayoutConstraint!
    
    //lblName
    @IBOutlet weak var leadingNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var altLeadingNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var altTrailingNameConstraint: NSLayoutConstraint!
    
    //lblMessage
    @IBOutlet weak var leadingMessageConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingMessageConstraint: NSLayoutConstraint!
    @IBOutlet weak var altLeadingMessageConstraint: NSLayoutConstraint!
    @IBOutlet weak var altTrailingMessageConstraint: NSLayoutConstraint!
    
    //lblDate
    @IBOutlet weak var leadingDateConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingDateConstraint: NSLayoutConstraint!
    @IBOutlet weak var altLeadingDateConstraint: NSLayoutConstraint!
    @IBOutlet weak var altTrailingDateConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
