//
//  APUser.swift
//  Prowdly
//
//  Created by Conny Hung on 18/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APUser: NSObject {
    var username = ""
    var password = ""
    var serverkey = ""
    var salt = ""
    var iterationcount = 0
    var created_at = ""
    var email = ""
    var phone = ""
    var fullname = ""
    var parent_user = ""
    var avatar_url = ""
    var handle = ""
//    var username = ""
//    var userId = ""
//    var firstName = ""
//    var lastName = ""
//    var avatarUrl = ""
//    var status = ""
//    var email = ""
//    var phoneNumber = ""
//    var location = ""
//    var dateBirth: UInt64 = 0
//    var occupation = ""
//    var relationType = ""
    
    static var currentUser = APUser()
    
    var isLoggedIn = false
    
    override init() {
        
    }
    
    init(json: [String : Any]) {
        self.username = json["username"] as! String
        self.password = json["password"] as! String
        self.serverkey = json["serverkey"] as! String
        self.salt = json["salt"] as! String
        self.iterationcount = json["iterationcount"] as! Int
        self.created_at = json["created_at"] as! String
        self.email = json["email"] as! String
        self.phone = json["phone"] as! String
        self.fullname = json["fullname"] as! String
        self.parent_user = json["parent_user"] as! String
        self.avatar_url = json["avatar_url"] as! String
        self.handle = json["handle"] as! String
    }
    
    func loadCurrentUser() {
        let userDefaults = UserDefaults.standard
        if let json = userDefaults.dictionary(forKey: kCURRENT_USER) {
            let user = APUser(json: json)
            APUser.currentUser = user
        }
    }
    
    func saveCurrentUser() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(toDictionary(), forKey: kCURRENT_USER)
    }
    
    func clearCurrentUser() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: kCURRENT_USER)
    }
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["username"] = self.username
        dictionary["password"] = self.username
        dictionary["serverkey"] = self.username
        dictionary["salt"] = self.username
        dictionary["iterationcount"] = self.username
        dictionary["created_at"] = self.username
        dictionary["email"] = self.username
        dictionary["phone"] = self.username
        dictionary["fullname"] = self.username
        dictionary["parent_user"] = self.username
        dictionary["avatar_url"] = self.username
        dictionary["handle"] = self.username
        return dictionary
    }
}
