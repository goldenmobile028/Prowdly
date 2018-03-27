//
//  APBaseViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 17/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APBaseViewController: UIViewController {

    public var isFirstAppear = true
    public var isPresent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: Any?) {
        if isPresent == true {
            self.dismiss(animated: true, completion: nil)
        } else if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
