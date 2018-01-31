//
//  APProfileHeaderView.swift
//  Prowdly
//
//  Created by Conny Hung on 22/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APProfileHeaderView: UIView {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var thumbLabel: UILabel!
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var thumbButton: UIButton!
    
    static func viewFromXib() -> APProfileHeaderView {
        let view = Bundle.main.loadNibNamed("APProfileHeaderView", owner: self, options: nil)?.first
        return view as! APProfileHeaderView
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - IBAction
    @IBAction func thumbButtonPressed(_ sender: UIButton?) {
        
    }

}
