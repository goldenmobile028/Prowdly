//
//  APGroupNameViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 19/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APGroupNameViewController: APBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var groupNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        groupNameTextField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        groupNameTextField.becomeFirstResponder()
    }
    

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "APGroupSelectViewController" {
            let controller = segue.destination as! APGroupSelectViewController
            controller.groupName = groupNameTextField.text!
        }
    }
    
    // MARK: - IBAction
    @IBAction func nextButtonPressed(_ sender: UIButton?) {
        if groupNameTextField.text == "" {
            return
        }
        
        let text = groupNameTextField.text!
        let words = text.components(separatedBy: " ")
        let spaces = words.count
        if text.count == spaces - 1 {
            return
        }
        
        performSegue(withIdentifier: "APGroupSelectViewController", sender: nil)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonPressed(nil)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let swiftRange = Range(range, in: textField.text!)
        let newText = textField.text?.replacingCharacters(in: swiftRange!, with: string)
        if newText == " " {
            return false
        }
        
        let components = newText!.components(separatedBy: "  ")
        if components.count > 1 {
            return false
        }
        
        return true
    }
}
