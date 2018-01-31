//
//  APChatReadCell.swift
//  Prowdly
//
//  Created by Conny Hung on 11/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APChatReadCell: APTableViewCell {
    
    @IBOutlet var readLabel: UILabel!
    
    var itemCount = 0 {
        didSet {
            readLabel.text = "Unread (\(itemCount))"
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
