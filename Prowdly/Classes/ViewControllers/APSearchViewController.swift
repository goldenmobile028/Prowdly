//
//  APSearchViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 18/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APSearchViewController: APBaseViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    
    private var friends: [APUser] = []
    private var chats: [APChat] = []
    private var searchFriends: [APUser] = []
    private var searchChats: [APChat] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchPeople(_ searchKey: String) {
        if searchKey == "" {
            friends = []
            chats = []
        } else {
            searchFriends = []
            searchChats = []
            for _ in 0...9 {
                let chat = APChat()
                chat.isUnread = false
                chats.append(chat)
            }
            
            for _ in 0...9 {
                let user = APUser()
                friends.append(user)
            }
        }
        searchTableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let swiftRange = Range(range, in: textField.text!)
        let searchKey = textField.text?.replacingCharacters(in: swiftRange!, with: string)
        searchPeople(searchKey!)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friends.count == 0, chats.count == 0 {
            return 0
        } else if friends.count == 0 {
            return chats.count + 1
        } else {
            return friends.count + chats.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if friends.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                cell.readLabel.text = "Chats"
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatViewCell", for: indexPath) as! APChatViewCell
                cell.chat = chats[indexPath.row - 1]
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                cell.readLabel.text = "Friends"
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                return cell
            } else if indexPath.row == friends.count + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                cell.readLabel.text = "Chats"
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                return cell
            } else if indexPath.row <= friends.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APFriendViewCell", for: indexPath) as! APFriendViewCell
                //cell.chat = friends[indexPath.row - 1]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatViewCell", for: indexPath) as! APChatViewCell
                //cell.chat = chats[indexPath.row - friends.count - 2]
                return cell
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if friends.count == 0 {
            if indexPath.row == 0 {
                return 44
            } else {
                return 80
            }
        } else {
            if indexPath.row == 0 || indexPath.row == friends.count + 1 {
                return 44
            } else if indexPath.row <= friends.count {
                return 68
            } else {
                return 80
            }
        }
    }
}
