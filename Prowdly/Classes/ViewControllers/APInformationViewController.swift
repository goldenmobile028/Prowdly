//
//  APInformationViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 22/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APInformationViewController: HVBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var titles = ["Email", "Phone Number", "Location", "Birthday", "Occupation", "Friends"]
    private var checkmarks = [true, true, false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "APProfileViewCell", for: indexPath) as! APProfileViewCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.checkImageView.isHidden = !checkmarks[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    // MARK: - APProfileHeaderCell
    func didSelectActivities() {
        
    }
    
    func didSelectInformation() {
        
    }
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
