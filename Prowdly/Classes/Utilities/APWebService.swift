//
//  APWebService.swift
//  Prowdly
//
//  Created by Hua Wan on 20/3/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit
import Alamofire

class APWebService: NSObject {
    static let shared = APWebService()
    
    // MARK: - User Relation Funcs
    func signin(email: String, password: String, completion: @escaping (_ response: [String : Any]?) -> Void) {
        let url = "\(SERVER_BASE_URL)/user?email=\(email)&password=\(password)"
        let escapedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(escapedUrl!, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                completion(response.result.value as! [String : Any]?)
            } else {
                completion(nil)
            }
        }
//        Alamofire.request(escapedUrl!).responseString { (response) in
//            if response.result.isSuccess {
//                print(response.result.value as! String)
////                completion(response.result.value as! String)
//            } else {
//                completion(nil)
//            }
//        }
//        Alamofire.request(escapedUrl!).responseJSON { (response: DataResponse<Any>) in
//            if response.result.isSuccess {
//                completion(response.result.value as! [String : Any]?)
//            } else {
//                completion(nil)
//            }
//        }
    }
    
    func signup(name: String, phone: String, email: String, password: String, completion: @escaping (_ response: [String : Any]?) -> Void) {
        let url = "\(SERVER_BASE_URL)/users/signup?email=\(email)&password=\(password)&user_type=1"
        let escapedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(escapedUrl!).responseJSON { (response: DataResponse<Any>) in
            if response.result.isSuccess {
                completion(response.result.value as! [String : Any]?)
            } else {
                completion(nil)
            }
        }
    }
}
