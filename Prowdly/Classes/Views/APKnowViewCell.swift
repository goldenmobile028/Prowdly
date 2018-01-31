//
//  APKnowViewCell.swift
//  Prowdly
//
//  Created by Conny Hung on 18/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

protocol APKnowViewCellDelegate {
    func didPressAddButton(_ cell: APKnowViewCell)
}

class APKnowViewCell: APTableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var thumbLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: APKnowViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButtonPressed(_ sender: UIButton?) {
        delegate?.didPressAddButton(self)
    }
}
