//
//  APFriendViewCell.swift
//  Prowdly
//
//  Created by Conny Hung on 18/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APFriendViewCell: APTableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var thumbLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton?
    
    var isSelection = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - IBAction
    @IBAction func selectionButtonPressed(_ sender: UIButton?) {
        isSelection = !isSelection
        if isSelection {
            selectionButton?.setImage(UIImage(named: "selected"), for: .normal)
        } else {
            selectionButton?.setImage(UIImage(named: "deselected"), for: .normal)
        }
    }
}
