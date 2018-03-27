//
//  APSettingsViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 11/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APSettingsViewController: APBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    let notifications = ["Chat Notification", "In-app Notifications", "In-app Sound", "In-app Vibration"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "APProfileViewController" {
            //let controller = segue.destination as! APProfileViewController
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "APSettingsHeaderCell", for: indexPath) as! APSettingsHeaderCell
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "APSettingsViewCell", for: indexPath) as! APSettingsViewCell
            cell.titleLabel.text = notifications[indexPath.row]
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 92
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "APNotificationsHeaderCell") as! APNotificationsHeaderCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 178
        } else {
            return 56
        }
    }
}
