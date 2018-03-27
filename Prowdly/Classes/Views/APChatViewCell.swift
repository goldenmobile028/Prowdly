//
//  APChatViewCell.swift
//  Prowdly
//
//  Created by Conny Hung on 11/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APChatViewCell: APTableViewCell {

    @IBOutlet private var thumbImageView: UIImageView!
    @IBOutlet weak var thumbLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var badgeLabel: UILabel!
    
    var chat: APChat = APChat() {
        didSet {
//            nameLabel.text = chat.senderName
//            messageLabel.text = chat.message
            timeLabel.text = chat.sendDate.formattedAsTimeAgo()
            badgeLabel.text = "\(chat.unreadCount)"
            if chat.isUnread {
                badgeLabel.isHidden = false
            } else {
                badgeLabel.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.masksToBounds = true
        thumbImageView.layer.cornerRadius = thumbImageView.frame.size.height / 2
        badgeLabel.layer.masksToBounds = true
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
