//
//  APChatsViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 11/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class APChatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APFavoritesViewCellDelegate, APTableViewCellDelegate {

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var chatsTableView: UITableView!
    @IBOutlet private var friendsTableView: UITableView!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var chatsButton: UIButton!
    @IBOutlet private var friendsButton: UIButton!
    @IBOutlet private var chatsImageView: UIImageView!
    @IBOutlet private var friendsImageView: UIImageView!
    
    let HEADER_HEIGHT: CGFloat = 44
    let CELL_HEIGHT: CGFloat = 80
    let FAVORITE_HEIGHT: CGFloat = 60
    let FRIEND_HEIGHT: CGFloat = 68
    
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
        
//        for _ in 0...9 {
//            let user = APUser()
//            favorites.append(user)
//        }
        
        for _ in 0...9 {
            let user = APUser()
            friends.append(user)
        }
        
//        for _ in 0...9 {
//            let user = APUser()
//            mayKnows.append(user)
//        }
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
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
            frame.origin.x = self.view.frame.size.width
            friendsTableView.frame = frame
            addButton.isHidden = false
            friendsTableView.isHidden = false
        }
        
        if UserDefaults.standard.string(forKey: "userID") != nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.connect() {
                //let title = appDelegate.xmppStream.myJID.bare()
                appDelegate.xmppRoster.fetch()
            }
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
        chatController.isPresent = true
        let navController = UINavigationController(rootViewController: chatController)
        navController.isNavigationBarHidden = true
        self.present(navController, animated: true, completion: nil)
    }
    
    func showUserProfile() {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true, duration: 0.2)
        }
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "APProfileViewController") as! APProfileViewController
        controller.isPresent = true
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
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
            chatController.isPresent = true
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
        let controller = storyboard.instantiateViewController(withIdentifier: "APSettingsViewController") as! APSettingsViewController
        controller.isPresent = true
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "APSearchViewController") as! APSearchViewController
        controller.isPresent = true
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true, duration: 0.2)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let controller = storyboard.instantiateViewController(withIdentifier: "APAddChatsViewController") as! APAddChatsViewController
        let controller = storyboard.instantiateViewController(withIdentifier: "APChooseFriendViewController") as! APChooseFriendViewController
        controller.isPresent = true
        let navController = UINavigationController(rootViewController: controller)
        navController.isNavigationBarHidden = true
        present(navController, animated: true, completion: nil)
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
            if section == 0 {
                return unreadChats.count > 0 ? unreadChats.count : readChats.count
            } else {
                return readChats.count
            }
        } else {
            if section == 0 {
                return favorites.count > 0 ? 1 : friends.count > 0 ? friends.count : mayKnows.count
            } else if section == 1 {
                return friends.count > 0 ? friends.count : mayKnows.count
            } else {
                return mayKnows.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == chatsTableView {
            if indexPath.section == 0, unreadChats.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatViewCell", for: indexPath) as! APChatViewCell
                cell.chat = unreadChats[indexPath.row]
                cell.actionDelegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APChatViewCell", for: indexPath) as! APChatViewCell
                cell.chat = readChats[indexPath.row]
                cell.actionDelegate = self
                return cell
            }
        } else {
            if indexPath.section == 0 {
                if favorites.count > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APFavoritesViewCell", for: indexPath) as! APFavoritesViewCell
                    cell.favorites = favorites
                    cell.delegate = self
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                    return cell
                } else if friends.count > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APFriendViewCell", for: indexPath) as! APFriendViewCell
                    //cell.chat = friends[indexPath.row]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APKnowViewCell", for: indexPath) as! APKnowViewCell
                    //cell.chat = mayKnow[indexPath.row]
                    return cell
                }
            } else if indexPath.section == 1 {
                if favorites.count > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APFriendViewCell", for: indexPath) as! APFriendViewCell
                    //cell.chat = friends[indexPath.row]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "APKnowViewCell", for: indexPath) as! APKnowViewCell
                    //cell.chat = mayKnow[indexPath.row]
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "APKnowViewCell", for: indexPath) as! APKnowViewCell
                //cell.chat = mayKnow[indexPath.row]
                return cell
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == chatsTableView {
            if indexPath.section == 0, unreadChats.count > 0 {
                showChatDetails()
                //cell.chat = unreadChats[indexPath.row]
            } else {
                showChatDetails()
                //cell.chat = readChats[indexPath.row]
            }
        } else {
            if indexPath.section == 0 {
                if favorites.count > 0 {
                    // Nothing
                } else if friends.count > 0 {
                    showUserProfile()
                    //cell.chat = friends[indexPath.row]
                } else {
                    showUserProfile()
                    //cell.chat = mayKnow[indexPath.row]
                }
            } else if indexPath.section == 1 {
                if friends.count > 0 {
                    showUserProfile()
                    //cell.chat = friends[indexPath.row]
                } else {
                    showUserProfile()
                    //cell.chat = mayKnow[indexPath.row]
                }
            } else {
                showUserProfile()
                //cell.chat = mayKnow[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == chatsTableView {
            return CELL_HEIGHT
        } else {
            if indexPath.section == 0 {
                if favorites.count > 0 {
                    return FAVORITE_HEIGHT
                } else if friends.count > 0 {
                    return FRIEND_HEIGHT
                } else {
                    return CELL_HEIGHT
                }
            } else if indexPath.section == 1 {
                if favorites.count > 0 {
                    return FRIEND_HEIGHT
                } else {
                    return CELL_HEIGHT
                }
            } else {
                return CELL_HEIGHT
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == chatsTableView {
            var sections = 0
            sections += unreadChats.count > 0 ? 1 : 0
            sections += readChats.count > 0 ? 1 : 0
            return sections
        } else {
            var sections = 0
            sections += favorites.count > 0 ? 1 : 0
            sections += friends.count > 0 ? 1 : 0
            sections += mayKnows.count > 0 ? 1 : 0
            return sections
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == chatsTableView {
            return 0
        } else {
            return 0//HEADER_HEIGHT
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: HEADER_HEIGHT))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 20, y: 18, width: 320, height: 24))
        label.font = FONT_POPPINS_REGULAR!
        view.addSubview(label)
        if tableView == chatsTableView {
            if section == 0 {
                label.text = unreadChats.count > 0 ? "Unread (\(unreadChats.count))" : "Chats (\(readChats.count))"
            } else {
                label.text = "Chats (\(readChats.count))"
            }
        } else {
            if section == 0 {
                if favorites.count > 0 {
                    label.text = "Favorites"
                } else if friends.count > 0 {
                    label.text = "Friends (\(friends.count))"
                } else {
                    label.text = "People You May Know"
                }
            } else if section == 1 {
                if favorites.count > 0 {
                    label.text = "Friends (\(friends.count))"
                } else {
                    label.text = "People You May Know"
                }
            } else {
                label.text = "People You May Know"
            }
        }
        return view
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
    
    // MARK: - APTableViewCellDelegate
    func didPressThumbButton(_ cell: APTableViewCell) {
        showUserProfile()
    }
}
