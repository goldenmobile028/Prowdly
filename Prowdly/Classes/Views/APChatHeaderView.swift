//
//  APChatHeaderView.swift
//  Prowdly
//
//  Created by Conny Hung on 26/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APChatHeaderView: UIView {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    static func viewFromXib() -> APChatHeaderView {
        let view = Bundle.main.loadNibNamed("APChatHeaderView", owner: self, options: nil)?.first
        return view as! APChatHeaderView
    }
}
