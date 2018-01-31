//
//  APSettingsHeaderCell.swift
//  Prowdly
//
//  Created by Conny Hung on 23/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APSettingsHeaderCell: APTableViewCell {
    
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var thumbLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
