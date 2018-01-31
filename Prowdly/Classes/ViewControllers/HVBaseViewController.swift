//
//  HVBaseViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 22/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class HVBaseViewController: APBaseViewController, UIScrollViewDelegate {

    public static let childScrollViewDidScroll = Notification.Name(rawValue: "ChildScrollViewDidScrollNSNotification")
    public static let childScrollViewRefreshState = Notification.Name(rawValue: "ChildScrollViewRefreshStateNSNotification")
    
    @IBOutlet weak var tableView: UITableView!
    
    var scrollView: UIScrollView? = nil;
    var headerView: UIView? = nil;
    
    var lastContentOffset = CGPoint(x: 0, y: 0)
    var isFirstViewLoaded = false
    var refreshState = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.contentInset = UIEdgeInsetsMake(kScrollViewBeginTopInset, 0, 0, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kScrollViewBeginTopInset, 0, 0, 0);
        
        self.scrollView = tableView
        
//        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.downPullUpdateData()
//        })
        
        if #available(iOS 11, *) {
            self.scrollView?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func downPullUpdateData() {
        self.tableView.mj_header.endRefreshing()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetDifference = scrollView.contentOffset.y - self.lastContentOffset.y;
        print(offsetDifference)
        NotificationCenter.default.post(name: HVBaseViewController.childScrollViewDidScroll, object: nil, userInfo: ["scrollingScrollView" : scrollView, "offsetDifference" : offsetDifference])
        self.lastContentOffset = scrollView.contentOffset;
    }
}
