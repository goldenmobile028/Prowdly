//
//  APChooseFriendViewController.swift
//  Prowdly
//
//  Created by Hua Wan on 6/3/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APChooseFriendViewController: APBaseViewController, UITableViewDataSource, UITableViewDelegate, APFriendViewCellDelegate, APTableViewCellDelegate {

    @IBOutlet weak var friendsTableView: UITableView!
    
    private var friends: [APUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
    
    func showUserProfile() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "APProfileViewController") as! APProfileViewController
        navigationController?.pushViewController(controller, animated: true)
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
        performSegue(withIdentifier: "APGroupChatViewController", sender: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "APFriendViewCell", for: indexPath) as! APFriendViewCell
        cell.delegate = self
        cell.actionDelegate = self
        //cell.chat = friends[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showUserProfile()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    // MARK: - APFriendViewCellDelegate
    func didSelectFriend(friend: APUser, selection: Bool) {
        
    }
    
    // MARK: - APTableViewCellDelegate
    func didPressThumbButton(_ cell: APTableViewCell) {
        showUserProfile()
    }
}
