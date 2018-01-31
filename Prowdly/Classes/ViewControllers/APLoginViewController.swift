//
//  APLoginViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 17/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APLoginViewController: APBaseViewController {

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
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "APPhoneNumberViewController", sender: nil)
    }

}
