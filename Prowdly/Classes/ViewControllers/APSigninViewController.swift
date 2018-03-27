//
//  APSigninViewController.swift
//  Prowdly
//
//  Created by Hua Wan on 20/3/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit
import Toast_Swift
import SVProgressHUD

class APSigninViewController: APBaseViewController, UITextFieldDelegate, ChatDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    private var keyboardHeight: CGFloat = 216
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func checkUserAbout(email: String, password: String) {
        if APUtilities.isValidEmail(email) == true {
            checkImageView.isHidden = false
        } else {
            if email == "" {
                checkImageView.isHidden = true
            }
        }
        
        if checkImageView.isHidden == false, password.count >= 7 {
            nextButton.isHidden = false
        } else {
            nextButton.isHidden = true
        }
        
//        if password.count < 7 {
//            showToastMessage(message: "")
//        }
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
    
    func handleSignin(response: [String : Any]?, password: String) {
        SVProgressHUD.dismiss()
        if response == nil {
            APUtilities.showToastMessage(message: "Cannot connect to server. Please try again.", fromView: self.view, keyboardHeight: keyboardHeight)
            return
        }
        
        let user = APUser(json: response!)
        user.saveCurrentUser()
        APUser.currentUser = user
        loginXMPP()
    }
    
    func showHomeViewController() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        present(controller!, animated: true, completion: nil)
    }
    
    func loginXMPP() {
        UserDefaults.standard.set(APUser.currentUser.username, forKey: "userID")
        UserDefaults.standard.set(passwordTextField.text!, forKey: "userPassword")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.connect() {
            showHomeViewController()
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
        SVProgressHUD.show()
        APWebService.shared.signin(email: emailTextField.text!, password: passwordTextField.text!) { (response) in
            self.handleSignin(response: response, password: self.passwordTextField.text!)
        }
    }
    
    @IBAction func termsButtonPressed(_ sender: UIButton) {
        //performSegue(withIdentifier: "", sender: nil)
    }
    
    @IBAction func privacyButtonPressed(_ sender: UIButton) {
        //performSegue(withIdentifier: "", sender: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextField.placeholder = "What's your email address?"
            checkImageView.isHidden = !checkEmail(email: emailTextField.text!)
            //checkImageView.isHidden = true
        } else if textField == passwordTextField {
            passwordTextField.placeholder = "Enter your password"
        }
        textField.font = textField.font?.withSize(20)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = checkUserAbout(email: emailTextField.text!, password: passwordTextField.text!)
        if textField == emailTextField {
            emailTextField.placeholder = "Email Address"
            _ = checkEmail(email: emailTextField.text!)
        } else if textField == passwordTextField {
            passwordTextField.placeholder = "Password"
        }
        textField.font = textField.font?.withSize(16)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let swiftRange = Range(range, in: textField.text!)
        let text = textField.text?.replacingCharacters(in: swiftRange!, with: string)
        if textField == emailTextField {
            checkImageView.isHidden = !checkEmail(email: text!)
            //checkImageView.isHidden = true
            checkUserAbout(email: text!, password: passwordTextField.text!)
        } else {
            checkUserAbout(email: emailTextField.text!, password: text!)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = checkUserAbout(email: emailTextField.text!, password: passwordTextField.text!)
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - ChatDelegate
    func buddyWentOnline(name: String) {
        print("buddyWentOnline")
//        if !onlineBuddies.containsObject(name) {
//            onlineBuddies.addObject(name)
//            tableView.reloadData()
//        }
    }
    
    func buddyWentOffline(name: String) {
        print("buddyWentOffline")
//        onlineBuddies.removeObject(name)
//        tableView.reloadData()
    }
    
    func didDisconnect() {
        print("didDisconnect")
//        onlineBuddies.removeAllObjects()
//        tableView.reloadData()
    }
}

