//
//  APGroupSelectViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 19/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class APGroupSelectViewController: APBaseViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var friendsTableView: UITableView!
    
    private var friends: [APUser] = []
    private var recents: [APUser] = []
    
    public var groupName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = groupName
        
        for _ in 0...9 {
            let user = APUser()
            friends.append(user)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchPeople(_ searchKey: String) {
        if searchKey == "" {
            friends = []
        } else {
            friends = []
            for _ in 0...9 {
                let user = APUser()
                friends.append(user)
            }
        }
        friendsTableView.reloadData()
    }
    
    func showUserProfile() {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true, duration: 0.2)
        }
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "APProfileViewController") as! APProfileViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "APGroupChatViewController" {
            let chatController = segue.destination as! APGroupChatViewController
            let pageSize = 50
            var dataSource: DemoChatDataSource!
            dataSource = DemoChatDataSource(count: 0, pageSize: pageSize)
            chatController.dataSource = dataSource
            chatController.messageSender = dataSource.messageSender
            chatController.chatName = groupName
        }
    }

    // MARK: - IBAction
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "APGroupChatViewController", sender: nil)
    }
    
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
        if friends.count == 0, recents.count == 0 {
            return 0
        } else if friends.count == 0 {
            return recents.count + 1
        } else {
            return friends.count + recents.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recents.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                cell.readLabel.text = "Friends (\(friends.count))"
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APFriendViewCell", for: indexPath) as! APFriendViewCell
                //cell.chat = friends[indexPath.row - 1]
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                cell.readLabel.text = "Recent"
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                return cell
            } else if indexPath.row == recents.count + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                cell.readLabel.text = "Friends (\(friends.count))"
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                return cell
            } else if indexPath.row <= recents.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APFriendViewCell", for: indexPath) as! APFriendViewCell
                //cell.chat = friends[indexPath.row - 1]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APFriendViewCell", for: indexPath) as! APFriendViewCell
                //cell.chat = chats[indexPath.row - friends.count - 2]
                return cell
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if recents.count == 0 {
            if indexPath.row == 0 {
                return 44
            } else {
                return 48
            }
        } else {
            if indexPath.row == 0 || indexPath.row == recents.count + 1 {
                return 44
            } else {
                return 48
            }
        }
    }
}
