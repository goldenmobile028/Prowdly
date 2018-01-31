//
//  APAboutViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 18/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APAboutViewController: APBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var progrossImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    private var progress: CGFloat = 0.4
    
    @IBOutlet private var widthProgressConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstAppear {
            isFirstAppear = false
            widthProgressConstraint.constant = self.view.frame.width * progress
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkUserAbout() -> CGFloat {
        var checkProgress = progress
        if nameTextField.text != "" {
            checkProgress += 0.1
        }
        
        if emailTextField.text != "" {
            checkProgress += 0.1
        }
        
        if APUtilities.isValidEmail(emailTextField.text!) == true {
            checkProgress += 0.1
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }
        
        if passwordTextField.text != "" {
            checkProgress += 0.1
        }
        
        if confirmTextField.text != "" {
            checkProgress += 0.1
        }
        
        if passwordTextField.text != "", passwordTextField.text == confirmTextField.text {
            checkProgress += 0.1
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.widthProgressConstraint.constant = self.view.frame.size.width * checkProgress
            self.view.layoutIfNeeded()
        })
        if fabs(1.0 - checkProgress) <= 0.001 {
            nextButton.isHidden = false
        } else {
            nextButton.isHidden = true
        }
        
        return checkProgress
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
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        progrossImageView.isHidden = true
        present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func termsButtonPressed(_ sender: UIButton) {
        //performSegue(withIdentifier: "", sender: nil)
    }
    
    @IBAction func privacyButtonPressed(_ sender: UIButton) {
        //performSegue(withIdentifier: "", sender: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            nameTextField.placeholder = "What's your name?"
        } else if textField == emailTextField {
            emailTextField.placeholder = "What's your email address?"
        } else if textField == passwordTextField {
            passwordTextField.placeholder = "Enter your password"
        } else {
            confirmTextField.placeholder = "Type again?!"
        }
        textField.font = textField.font?.withSize(20)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            nameTextField.placeholder = "Name"
        } else if textField == emailTextField {
            emailTextField.placeholder = "Email Address"
        } else if textField == passwordTextField {
            passwordTextField.placeholder = "Password"
        } else {
            confirmTextField.placeholder = "Confirm Password"
        }
        textField.font = textField.font?.withSize(16)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let swiftRange = Range(range, in: textField.text!)
        let text = textField.text?.replacingCharacters(in: swiftRange!, with: string)
        var checkProgress = checkUserAbout()
        if text == "" {
            checkProgress -= 0.1
        } else if textField.text == "" {
            checkProgress += 0.1
            UIView.animate(withDuration: 0.3, animations: {
                self.widthProgressConstraint.constant = self.view.frame.size.width * checkProgress
                self.view.layoutIfNeeded()
            })
            if fabs(1.0 - checkProgress) <= 0.001 {
                nextButton.isHidden = false
            } else {
                nextButton.isHidden = true
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            _ = checkUserAbout()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            _ = checkUserAbout()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            _ = checkUserAbout()
            confirmTextField.becomeFirstResponder()
        } else {
            _ = checkUserAbout()
            textField.resignFirstResponder()
        }
        return true
    }
}
