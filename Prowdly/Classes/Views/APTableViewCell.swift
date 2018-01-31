//
//  APTableViewCell.swift
//  Prowdly
//
//  Created by Conny Hung on 25/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

protocol APTableViewCellDelegate {
    func didPressThumbButton(_ cell: APTableViewCell)
}

class APTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbButton: UIButton? = nil
    
    var actionDelegate: APTableViewCellDelegate? = nil
    var cellIndex = -1

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func thumbButtonPressed(_ sender: UIButton?) {
        actionDelegate?.didPressThumbButton(self)
    }
}
