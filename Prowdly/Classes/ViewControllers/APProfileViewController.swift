//
//  APProfileViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 19/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APProfileViewController: APBaseViewController, UIScrollViewDelegate, SPPageMenuDelegate {

    @IBOutlet weak var chatButton: UIButton!
    
    var closeButton: UIButton!
    var titleLabel: UILabel!
    var scrollView: UIScrollView!
    var headerView: APProfileHeaderView!
    var pageMenu: SPPageMenu!
    
    var lastPageMenuY: CGFloat = 0.0
    var lastPoint = CGPoint(x: 0, y: 0)
    
    let kHeaderViewH: CGFloat = 88
    let kPageMenuH: CGFloat = 40
    let isIPhoneX = kScreenH == 812
//    let kNaviH = (isIPhoneX ? 84 : 64)
    let kNaviH: CGFloat = 64
    let kNaviHeaderH: CGFloat = 72
//    let bottomMargin = (isIPhoneX ? 34 : 0)
    let bottomMargin = 0
    
    private var isActivitiesSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - CGFloat(bottomMargin))
        scrollView.delegate = self;
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: kScreenW * 2, height: 0)
        scrollView.contentSize = CGSize(width: 0, height: 0)
        scrollView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(scrollView)
        
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kNaviHeaderH + 20))
        emptyView.backgroundColor = .white
        self.view.addSubview(emptyView)
        
        closeButton = UIButton(frame: CGRect(x: 8, y: 28, width: 44, height: 44))
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        titleLabel = UILabel(frame: CGRect(x: 60, y: 28, width: kScreenW - 120, height: 44))
        titleLabel.text = "Hailee Steinfeld"
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        titleLabel.alpha = 0.0
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        headerView = APProfileHeaderView.viewFromXib()
        headerView.frame = CGRect(x: 0, y: kNaviHeaderH, width: kScreenW, height: kHeaderViewH)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
        headerView.addGestureRecognizer(pan)
        self.view.addSubview(headerView)
        
        let naviView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kNaviHeaderH))
        naviView.backgroundColor = .white
        self.view.addSubview(naviView)
        self.view.bringSubview(toFront: closeButton)
        self.view.bringSubview(toFront: titleLabel)
        
        let frame = CGRect(x: CGFloat(0), y: headerView.frame.origin.y + headerView.frame.size.height, width: kScreenW, height: kPageMenuH)
        pageMenu = SPPageMenu(frame: frame, trackerStyle: SPPageMenuTrackerStyle.lineLongerThanItem)
        pageMenu.setItems(["Activities", "Information"], selectedItemIndex: 0)
        pageMenu.delegate = self
        pageMenu.itemTitleFont = UIFont(name: "Poppins-Regular", size: 14)!
        pageMenu.selectedItemTitleColor = COLOR_HIGHLIGHT
        pageMenu.unSelectedItemTitleColor = COLOR_DEACTIVE
        pageMenu.permutationWay = SPPageMenuPermutationWay.notScrollEqualWidths
        pageMenu.bridgeScrollView = self.scrollView
        pageMenu.tracker.backgroundColor = .clear
        self.view.addSubview(pageMenu)
        
        self.view.bringSubview(toFront: closeButton)
        self.view.bringSubview(toFront: chatButton)
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let activitiesViewController = storyboard.instantiateViewController(withIdentifier: "APActivitiesViewController") as! APActivitiesViewController
        self.addChildViewController(activitiesViewController)
        let informationViewController = storyboard.instantiateViewController(withIdentifier: "APInformationViewController") as! APInformationViewController
        self.addChildViewController(informationViewController)
        
        self.scrollView.addSubview(self.childViewControllers[0].view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(subScrollViewDidScroll(_:)), name: HVBaseViewController.childScrollViewDidScroll, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func subScrollViewDidScroll(_ notification: Notification) {
        let scrollingScrollView = notification.userInfo!["scrollingScrollView"] as! UIScrollView
        let offsetDifference = notification.userInfo!["offsetDifference"]as! CGFloat
        var distanceY = CGFloat(0)
        
        let baseVC = self.childViewControllers[Int(pageMenu.selectedItemIndex)] as! HVBaseViewController
        if scrollingScrollView == baseVC.scrollView, baseVC.isFirstViewLoaded == false {
            var pageMenuFrame = pageMenu.frame
            if pageMenuFrame.origin.y >= kNaviHeaderH {
                if offsetDifference > 0, scrollingScrollView.contentOffset.y + kScrollViewBeginTopInset > 0 {
                    if scrollingScrollView.contentOffset.y + kScrollViewBeginTopInset + pageMenu.frame.origin.y >= kHeaderViewH || scrollingScrollView.contentOffset.y + kScrollViewBeginTopInset < 0 {
                        pageMenuFrame.origin.y += -offsetDifference
                        if (pageMenuFrame.origin.y <= kNaviHeaderH) {
                            pageMenuFrame.origin.y = kNaviHeaderH
                        }
                    }
                } else {
                    if scrollingScrollView.contentOffset.y + kScrollViewBeginTopInset + pageMenu.frame.origin.y < kHeaderViewH + kNaviHeaderH {
                        pageMenuFrame.origin.y = -scrollingScrollView.contentOffset.y - kScrollViewBeginTopInset + kHeaderViewH + kNaviHeaderH
                        if pageMenuFrame.origin.y >= kHeaderViewH + kNaviHeaderH {
                            pageMenuFrame.origin.y = kHeaderViewH + kNaviHeaderH
                        }
                    }
                }
            }
            
            pageMenu.frame = pageMenuFrame
            var headerFrame = headerView.frame
            headerFrame.origin.y = self.pageMenu.frame.origin.y - kHeaderViewH
            self.headerView.frame = headerFrame
            
            distanceY = pageMenuFrame.origin.y - lastPageMenuY
            lastPageMenuY = self.pageMenu.frame.origin.y
            
            self.followScrollingScrollView(scrollingScrollView, distanceY)
            
            self.updateTitleLabel(-pageMenu.frame.origin.y + kHeaderViewH + kNaviHeaderH)
        }
        
        baseVC.isFirstViewLoaded = false
    }
    
    func followScrollingScrollView(_ scrollView: UIScrollView, _ distanceY: CGFloat) {
        var baseVC: HVBaseViewController? = nil
        for i in 0...self.childViewControllers.count - 1 {
            baseVC = self.childViewControllers[i] as? HVBaseViewController
            if baseVC?.scrollView != scrollView {
                var contentOffset = baseVC?.scrollView?.contentOffset
                contentOffset?.y += distanceY
                baseVC?.scrollView?.contentOffset = contentOffset!
            }
        }
    }
    
    func updateTitleLabel(_ offsetY: CGFloat) {
        if offsetY >= 0 {
            let alpha = offsetY / (kHeaderViewH + kNaviHeaderH - kNaviHeaderH)
            titleLabel.alpha = alpha
        } else {
            titleLabel.alpha = 0;
        }
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
    @IBAction func activitiesButtonPressed(_ sender: UIButton?) {
//        activitiesButton.setTitleColor(COLOR_HIGHLIGHT, for: .normal)
//        informationButton.setTitleColor(COLOR_DEACTIVE, for: .normal)
//        didSelectActivities()
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatController = storyboard.instantiateViewController(withIdentifier: "APGroupChatViewController") as! APGroupChatViewController
        let pageSize = 50
        var dataSource: DemoChatDataSource!
        dataSource = DemoChatDataSource(count: 0, pageSize: pageSize)
        chatController.dataSource = dataSource
        chatController.messageSender = dataSource.messageSender
        chatController.chatName = "Hailee Steinfeld"
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let baseVC = self.childViewControllers[Int(self.pageMenu.selectedItemIndex)] as! HVBaseViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (baseVC.scrollView?.contentSize.height)! < kScreenH, baseVC.isViewLoaded {
                baseVC.scrollView?.setContentOffset(CGPoint(x: 0, y: -kScrollViewBeginTopInset), animated: true)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let baseVC = self.childViewControllers[Int(self.pageMenu.selectedItemIndex)] as! HVBaseViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (baseVC.scrollView?.contentSize.height)! < kScreenH, baseVC.isViewLoaded {
                baseVC.scrollView?.setContentOffset(CGPoint(x: 0, y: -kScrollViewBeginTopInset), animated: true)
            }
        }
    }
    
    // MARK: - UIGestureRecognizer Handlers
    @objc func handlePanGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            
        } else if sender.state == .changed {
            let currentPoint = sender.translation(in: sender.view)
            let distanceY = currentPoint.y - lastPoint.y
            lastPoint = currentPoint
            
            let baseVC = self.childViewControllers[Int(pageMenu.selectedItemIndex)] as! HVBaseViewController
            var offset = (baseVC.scrollView?.contentOffset)!
            offset.y += -distanceY;
            if (offset.y <= -kScrollViewBeginTopInset) {
                offset.y = -kScrollViewBeginTopInset;
            }
            baseVC.scrollView?.contentOffset = offset;
        } else {
            sender.setTranslation(CGPoint.zero, in: sender.view)
            self.lastPoint = CGPoint.zero;
        }
    }
    
    // MARK: - SPPageMenuDelegate Handlers
    func pageMenu(_ pageMenu: SPPageMenu, itemSelectedFrom fromIndex: Int, to toIndex: Int) {
        if self.childViewControllers.count == 0 {
            return
        }
        self.scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * CGFloat(toIndex), y: 0), animated: true)
        
        let targetViewController = self.childViewControllers[toIndex] as! HVBaseViewController
        if targetViewController.isViewLoaded {
            return
        }
        targetViewController.isFirstViewLoaded = true
        targetViewController.view.frame = CGRect(x: kScreenW * CGFloat(toIndex), y: 0, width: kScreenW, height: kScreenH)
        
//        let targetScrollViw = targetViewController.scrollView
//        var contentOffset = (targetScrollViw?.contentOffset)!
//        contentOffset.y -= headerView.frame.origin.y - kScrollViewBeginTopInset
//        if (contentOffset.y + kScrollViewBeginTopInset >= kHeaderViewH) {
//            contentOffset.y = kHeaderViewH - kScrollViewBeginTopInset;
//        }
//        targetScrollViw?.contentOffset = contentOffset;
        self.scrollView.addSubview(targetViewController.view)
    }
}
