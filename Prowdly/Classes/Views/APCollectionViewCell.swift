//
//  APCollectionViewCell.swift
//  Prowdly
//
//  Created by Conny Hung on 25/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

protocol APCollectionViewCellDelegate {
    func didPressThumbButton(_ cell: APCollectionViewCell)
}

class APCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbButton: UIButton? = nil
    
    var actionDelegate: APCollectionViewCellDelegate? = nil
    var cellIndex = -1
    
    @IBAction func thumbButtonPressed(_ sender: UIButton?) {
        actionDelegate?.didPressThumbButton(self)
    }
}
