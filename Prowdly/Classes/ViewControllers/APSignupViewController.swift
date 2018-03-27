//
//  APSignupViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 18/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit
import Toast_Swift

class APSignupViewController: APBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var progrossImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    private var progress: CGFloat = 0.4
    private var keyboardHeight: CGFloat = 216
    
    @IBOutlet private var widthProgressConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
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
    
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardFrame.height
    }
    
    func checkUserAbout(name: String, email: String, password: String, confirm: String) -> CGFloat {
        var checkProgress = progress
        if name != "" {
            checkProgress += 0.1
        }
        
        if email != "" {
            checkProgress += 0.1
        }
        
        if APUtilities.isValidEmail(email) == true {
            checkProgress += 0.1
            checkImageView.isHidden = false
        } else {
            if email == "" {
                checkImageView.isHidden = true
            }
        }
        
        if password != "" {
            checkProgress += 0.1
        }
        
        if confirm != "" {
            checkProgress += 0.1
        }
        
        if password != "", password == confirm {
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
    
    func checkEmail(email: String) -> Bool {
        if email != "" {
            checkImageView.isHidden = false
            if APUtilities.isValidEmail(email) == true {
                checkImageView.image = UIImage(named: "check")
                return true
            } else {
                checkImageView.image = UIImage(named: "invalid")
                return false
            }
        } else {
            checkImageView.isHidden = true
            return false
        }
    }
    
    func checkPasswordMatch(password: String, confirm: String) {
        if password != "", confirm != "", password != confirm {
            APUtilities.showToastMessage(message: "Sorry, passwords don’t match", fromView: self.view, keyboardHeight: keyboardHeight)
        }
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
            checkImageView.isHidden = !checkEmail(email: emailTextField.text!)
            //checkImageView.isHidden = true
        } else if textField == passwordTextField {
            passwordTextField.placeholder = "Enter your password"
        } else {
            confirmTextField.placeholder = "Type again?!"
        }
        textField.font = textField.font?.withSize(20)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = checkUserAbout(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, confirm: confirmTextField.text!)
        if textField == nameTextField {
            nameTextField.placeholder = "Name"
        } else if textField == emailTextField {
            emailTextField.placeholder = "Email Address"
            _ = checkEmail(email: emailTextField.text!)
        } else if textField == passwordTextField {
            passwordTextField.placeholder = "Password"
            checkPasswordMatch(password: passwordTextField.text!, confirm: confirmTextField.text!)
        } else {
            confirmTextField.placeholder = "Confirm Password"
            checkPasswordMatch(password: passwordTextField.text!, confirm: confirmTextField.text!)
        }
        textField.font = textField.font?.withSize(16)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let swiftRange = Range(range, in: textField.text!)
        let text = textField.text?.replacingCharacters(in: swiftRange!, with: string)
        var checkProgress: CGFloat = 0
        if textField == nameTextField {
            checkProgress = checkUserAbout(name: text!, email: emailTextField.text!, password: passwordTextField.text!, confirm: confirmTextField.text!)
        } else if textField == emailTextField {
            checkProgress = checkUserAbout(name: nameTextField.text!, email: text!, password: passwordTextField.text!, confirm: confirmTextField.text!)
            checkImageView.isHidden = !checkEmail(email: text!)
            //checkImageView.isHidden = true
        } else if textField == passwordTextField {
            checkProgress = checkUserAbout(name: nameTextField.text!, email: emailTextField.text!, password: text!, confirm: confirmTextField.text!)
        } else {
            checkProgress = checkUserAbout(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, confirm: text!)
        }
        if text == "" {
            checkProgress -= 0.1
        } else if textField.text == "" {
            UIView.animate(withDuration: 0.3, animations: {
                self.widthProgressConstraint.constant = self.view.frame.size.width * checkProgress
                self.view.layoutIfNeeded()
            })
            if fabs(1.0 - checkProgress) <= 0.001 {
                nextButton.isHidden = false
                checkImageView.isHidden = false
            } else {
                nextButton.isHidden = true
                //checkImageView.isHidden = true
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = checkUserAbout(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, confirm: confirmTextField.text!)
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
