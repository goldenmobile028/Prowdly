//
//  APPhoneNumberViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 18/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit
import CountryPicker
import PhoneNumberKit

class APPhoneNumberViewController: APBaseViewController, CountryPickerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneTextField: PhoneNumberTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var countryPicker: CountryPicker!
    
    @IBOutlet private var widthProgressConstraint: NSLayoutConstraint!

    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        countryPicker.countryPickerDelegate = self
        countryPicker.setCountry("CA")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkPhoneNumber(_ phoneNumber: String) {
        do {
            let number = try phoneNumberKit.parse(phoneNumber)
            print(number)
            nextButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.widthProgressConstraint.constant = self.view.frame.size.width * 0.2
                self.view.layoutIfNeeded()
            })
        } catch {
            print("parse error")
            nextButton.isHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                self.widthProgressConstraint.constant = 0
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
    @IBAction func countryButtonPressed(_ sender: UIButton) {
        phoneTextField.resignFirstResponder()
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "APPhoneVerifyViewController", sender: nil)
    }
    
    // MARK: - CountryPickerDelegate
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        flagImageView.image = flag
        countryLabel.text = name
        phoneTextField.text = phoneCode
        checkPhoneNumber(phoneTextField.text!)
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let swiftRange = Range(range, in: textField.text!)
        let phoneNumber = textField.text?.replacingCharacters(in: swiftRange!, with: string)
        print(phoneNumber)
        checkPhoneNumber(phoneNumber!)
        return true
    }
}
