//
//  APSettingsViewCell.swift
//  Prowdly
//
//  Created by Conny Hung on 23/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APSettingsViewCell: APTableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var checkSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
