//
//  APPhoneVerifyViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 18/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APPhoneVerifyViewController: APBaseViewController, PinCodeTextFieldDelegate {

    @IBOutlet weak var pincodeTextField: PinCodeTextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet private var widthProgressConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pincodeTextField.delegate = self
        pincodeTextField.keyboardType = .numberPad
        pincodeTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstAppear {
            isFirstAppear = false
            widthProgressConstraint.constant = self.view.frame.width * 0.2
        }
    }
    
    func checkPhoneCode(_ phoneCode: String) {
        if phoneCode.characters.count == 6 {
            nextButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.widthProgressConstraint.constant = self.view.frame.size.width * 0.4
                self.view.layoutIfNeeded()
            })
        } else {
            nextButton.isHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                self.widthProgressConstraint.constant = self.view.frame.size.width * 0.2
                self.view.layoutIfNeeded()
            })
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
    @IBAction func resendButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "APSignupViewController", sender: nil)
    }
    
    // MARK: - PinCodeTextFieldDelegate
    func textFieldDidEndEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        checkPhoneCode(textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return false
    }
}
