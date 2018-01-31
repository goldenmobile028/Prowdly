//
//  APChatsViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 11/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class APChatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APFavoritesViewCellDelegate {

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var chatsTableView: UITableView!
    @IBOutlet private var friendsTableView: UITableView!
    @IBOutlet private var chatsButton: UIButton!
    @IBOutlet private var friendsButton: UIButton!
    @IBOutlet private var chatsImageView: UIImageView!
    @IBOutlet private var friendsImageView: UIImageView!
    
    var unreadChats: [APChat] = []
    var readChats: [APChat] = []
    var friends: [APUser] = []
    var mayKnows: [APUser] = []
    var favorites: [APUser] = []
    var chatsSelected = true
    
    var isFirstAppear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for i in 0...2 {
            let chat = APChat()
            chat.unreadCount = i + 2
            chat.isUnread = true
            unreadChats.append(chat)
        }
        
        for _ in 0...9 {
            let chat = APChat()
            chat.isUnread = false
            readChats.append(chat)
        }
        
        for _ in 0...9 {
            let user = APUser()
            favorites.append(user)
        }
        
        for _ in 0...9 {
            let user = APUser()
            friends.append(user)
        }
        
        for _ in 0...9 {
            let user = APUser()
            mayKnows.append(user)
        }
        
        friendsTableView.isHidden = true
//        if #available(iOS 11, *) {
            if let navigationController = self.navigationController as? ScrollingNavigationController {
                navigationController.followScrollView(chatsTableView, delay: 48)
            }
//        } else {
//            self.shyNavBarManager.scrollView = chatsTableView
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstAppear == true {
            isFirstAppear = false
            var frame = friendsTableView.frame
            frame.origin.x = self.view.frame.size.width
            friendsTableView.frame = frame
            friendsTableView.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showChatDetails() {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true, duration: 0.2)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatController = storyboard.instantiateViewController(withIdentifier: "APGroupChatViewController") as! APGroupChatViewController
        let initialCount = 2
        let pageSize = 50
        
        let dataSource = DemoChatDataSource(count: initialCount, pageSize: pageSize)
        chatController.dataSource = dataSource
        chatController.messageSender = dataSource.messageSender
        navigationController?.pushViewController(chatController, animated: true)
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
            
            let initialCount = 2
            let pageSize = 50
            
            let dataSource = DemoChatDataSource(count: initialCount, pageSize: pageSize)
            chatController.dataSource = dataSource
            chatController.messageSender = dataSource.messageSender
        }
    }
    
    // MARK: - IBAction
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "APProfileViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "APSettingsViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "APSearchViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "APAddChatsViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func chatsButtonPressed(_ sender: UIButton) {
        if chatsSelected {
            return
        }
        chatsSelected = true
        didSelectChats()
        chatsButton.setTitleColor(COLOR_HIGHLIGHT, for: .normal)
        friendsButton.setTitleColor(COLOR_DEACTIVE, for: .normal)
        chatsImageView.isHidden = false
        friendsImageView.isHidden = true
    }
    
    @IBAction func friendsButtonPressed(_ sender: UIButton) {
        if !chatsSelected {
            return
        }
        chatsSelected = false
        didSelectFriends()
        friendsButton.setTitleColor(COLOR_HIGHLIGHT, for: .normal)
        chatsButton.setTitleColor(COLOR_DEACTIVE, for: .normal)
        chatsImageView.isHidden = true
        friendsImageView.isHidden = false
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == chatsTableView {
            if unreadChats.count == 0, readChats.count == 0 {
                return 0
            } else if unreadChats.count == 0 {
                return readChats.count + 1
            } else {
                return unreadChats.count + readChats.count + 2
            }
        } else {
            if favorites.count == 0, friends.count == 0, mayKnows.count == 0 {
                return 0
            } else if favorites.count == 0, friends.count == 0 {
                return mayKnows.count + 1
            } else if favorites.count == 0 {
                return friends.count + mayKnows.count + 2
            } else {
                return friends.count + mayKnows.count + 3
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == chatsTableView {
            if unreadChats.count == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                    cell.readLabel.text = "Chats (\(readChats.count))"
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatViewCell", for: indexPath) as! APChatViewCell
                    cell.chat = readChats[indexPath.row - 1]
                    return cell
                }
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                    cell.readLabel.text = "Unread (\(unreadChats.count))"
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else if indexPath.row == unreadChats.count + 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                    cell.readLabel.text = "Chats (\(readChats.count))"
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else if indexPath.row <= unreadChats.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatViewCell", for: indexPath) as! APChatViewCell
                    cell.chat = unreadChats[indexPath.row - 1]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatViewCell", for: indexPath) as! APChatViewCell
                    cell.chat = readChats[indexPath.row - unreadChats.count - 2]
                    return cell
                }
            }
        } else {
            if favorites.count == 0, friends.count == 0, mayKnows.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatViewCell", for: indexPath) as! APChatViewCell
                return cell // fake
            } else if favorites.count == 0, friends.count == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                    cell.readLabel.text = "People You May Know"
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APKnowViewCell", for: indexPath) as! APKnowViewCell
                    //cell.chat = readChats[indexPath.row - 1]
                    return cell
                }
            } else if favorites.count == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                    cell.readLabel.text = "Friends (\(friends.count))"
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else if indexPath.row == friends.count + 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                    cell.readLabel.text = "People You May Know"
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else if indexPath.row <= friends.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APFriendViewCell", for: indexPath) as! APFriendViewCell
                    //cell.chat = friends[indexPath.row - 1]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APKnowViewCell", for: indexPath) as! APKnowViewCell
                    //cell.chat = mayKnow[indexPath.row - friends.count - 2]
                    return cell
                }
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APFavoritesViewCell", for: indexPath) as! APFavoritesViewCell
                    cell.favorites = favorites
                    cell.delegate = self
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                    cell.readLabel.text = "Friends (\(friends.count))"
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else if indexPath.row == friends.count + 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APChatReadCell", for: indexPath) as! APChatReadCell
                    cell.readLabel.text = "People You May Know"
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else if indexPath.row <= friends.count + 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APFriendViewCell", for: indexPath) as! APFriendViewCell
                    //cell.chat = friends[indexPath.row - 1]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APKnowViewCell", for: indexPath) as! APKnowViewCell
                    //cell.chat = mayKnow[indexPath.row - friends.count - 2]
                    return cell
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == chatsTableView {
            if unreadChats.count == 0 {
                if indexPath.row != 0 {
                    showChatDetails()
                    //cell.chat = readChats[indexPath.row - 1]
                }
            } else {
                if indexPath.row == 0 || indexPath.row == unreadChats.count + 1 {
                    return
                }
                if indexPath.row <= unreadChats.count {
                    showChatDetails()
                    //cell.chat = unreadChats[indexPath.row - 1]
                } else {
                    showChatDetails()
                    //cell.chat = readChats[indexPath.row - unreadChats.count - 2]
                }
            }
        } else {
            if favorites.count == 0, friends.count == 0, mayKnows.count == 0 {
                return // fake
            } else if favorites.count == 0, friends.count == 0 {
                if indexPath.row != 0 {
                    showUserProfile()
                    //cell.chat = mayKnows[indexPath.row - 1]
                }
            } else if favorites.count == 0 {
                if indexPath.row == 0 || indexPath.row == friends.count + 1 {
                    return
                }
                if indexPath.row <= friends.count {
                    showChatDetails()
                    //cell.chat = friends[indexPath.row - 1]
                } else {
                    showUserProfile()
                    //cell.chat = mayKnow[indexPath.row - friends.count - 2]
                }
            } else {
                if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == friends.count + 2 {
                    return
                }
                if indexPath.row <= friends.count + 1 {
                    showChatDetails()
                    //cell.chat = friends[indexPath.row - 1]
                } else {
                    showUserProfile()
                    //cell.chat = mayKnow[indexPath.row - friends.count - 2]
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == chatsTableView {
            if unreadChats.count == 0 {
                if indexPath.row == 0 {
                    return 44
                } else {
                    return 60
                }
            } else {
                if indexPath.row == 0 || indexPath.row == unreadChats.count + 1 {
                    return 44
                } else {
                    return 60
                }
            }
        } else {
            if favorites.count == 0, friends.count == 0, mayKnows.count == 0 {
                return 0
            } else if favorites.count == 0, friends.count == 0 {
                if indexPath.row == 0 {
                    return 44
                } else {
                    return 60
                }
            } else if favorites.count == 0 {
                if indexPath.row == 0 || indexPath.row == friends.count + 1 {
                    return 44
                } else if indexPath.row <= friends.count {
                    return 48
                } else {
                    return 60
                }
            } else {
                if indexPath.row == 0 {
                    return 84
                } else if indexPath.row == 1 || indexPath.row == friends.count + 2 {
                    return 44
                } else if indexPath.row <= friends.count + 1 {
                    return 48
                } else {
                    return 60
                }
            }
        }
    }
    
    // MARK: - APChatHeaderCellDelegate
    func didSelectChats() {
        chatsSelected = true
//        if #available(iOS 11, *) {
            if let navigationController = self.navigationController as? ScrollingNavigationController {
                navigationController.followScrollView(chatsTableView, delay: 50.0)
            }
//        } else {
//            self.shyNavBarManager.scrollView = chatsTableView
//        }
        UIView.animate(withDuration: 0.3) {
            var frame = self.chatsTableView.frame
            frame.origin.x = 0
            self.chatsTableView.frame = frame
            frame = self.friendsTableView.frame
            frame.origin.x = self.view.frame.size.width
            self.friendsTableView.frame = frame
        }
        chatsTableView.reloadData()
    }
    
    func didSelectFriends() {
        chatsSelected = false
//        if #available(iOS 11, *) {
            if let navigationController = self.navigationController as? ScrollingNavigationController {
                navigationController.followScrollView(friendsTableView, delay: 50.0)
            }
//        } else {
//            self.shyNavBarManager.scrollView = friendsTableView
//        }
        UIView.animate(withDuration: 0.3) {
            var frame = self.chatsTableView.frame
            frame.origin.x = -self.chatsTableView.frame.size.width
            self.chatsTableView.frame = frame
            frame = self.friendsTableView.frame
            frame.origin.x = 0
            self.friendsTableView.frame = frame
        }
        friendsTableView.reloadData()
    }
    
    // MARK: - APFavoritesViewCellDelegate
    func didSelectUser(_ userId: String) {
        showUserProfile()
    }
}
