//
//  MainTabBarViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    private lazy var recentTransactionViewController: RecentTransactionsViewController = {
        let _viewController = RecentTransactionsViewController()
        let _tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        _viewController.tabBarItem = _tabBarItem
        
        return _viewController
    }()
    private lazy var membersViewController: MembersViewController = {
        let _viewController = MembersViewController()
        let _tabBarItem = UITabBarItem(title: "Members", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        _viewController.tabBarItem = _tabBarItem
        
        return _viewController
    }()
    private lazy var oneTimePaymentViewController: OneTimePaymentViewController = {
        let _viewController = OneTimePaymentViewController()
        let _tabBarItem = UITabBarItem(title: "One-Time Payments", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        _viewController.tabBarItem = _tabBarItem
        
        return _viewController
    }()
    private lazy var subscribeViewController: SubscribeViewController = {
        let _viewController = SubscribeViewController()
        let _tabBarItem = UITabBarItem(title: "Subscribe", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        _viewController.tabBarItem = _tabBarItem
        
        return _viewController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barStyle = .Black
        self.tabBar.tintColor = .whiteColor()
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewControllers = [recentTransactionViewController, membersViewController, oneTimePaymentViewController, subscribeViewController]
    }
}
extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        //do nothing
    }
}