//
//  APUtilities.swift
//  Prowdly
//
//  Created by Conny Hung on 18/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit
import Toast_Swift

class APUtilities: NSObject {
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailValidate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailValidate.evaluate(with: email)
        return result
    }
    
    static func isValidName(_ name: String) -> Bool {
        let nameRegEx = "[A-Z0-9a-z._%+-]"
        let nameValidate = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        let result = nameValidate.evaluate(with: name)
        return result
    }
    
    static func showToastMessage(message: String, fromView: UIView, keyboardHeight: CGFloat) {
        var style = ToastStyle()
        style.backgroundColor = COLOR_HIGHLIGHT
        style.messageColor = .white
        style.messageFont = FONT_POPPINS_REGULAR!
        ToastManager.shared.isTapToDismissEnabled = true
        //self.view.makeToast("Sorry, passwords don’t match", duration: 3.0, position: .top, style: style)
        ToastManager.shared.style = style
        fromView.makeToast(message, point: CGPoint(x: fromView.bounds.width / 2.0, y: fromView.bounds.height - keyboardHeight - 32), title: nil, image: nil, completion: nil)
    }

    func generateMaskImage(_ size: CGSize) -> UIImage {
        var image = UIImage(named: "")  // Hexapod image
        let min = fmaxf(Float(size.width), Float(size.height))
        let resize = CGSize(width: CGFloat(min), height: CGFloat(min))
        image = self.resizeImage(image!, size: resize)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        UIGraphicsEndImageContext()
        return image!
    }
    
    func resizeImage(_ image: UIImage, size: CGSize) -> UIImage {
        return image
    }
}
