//
//  MenuViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SWRevealViewController

class MenuViewController: UIViewController {
    private let menuHeaderCellIdentifier        = "MenuHeaderCellIdentifier"
    private let menuItemCellIdentifier          = "MenuItemCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
    private let menuItems = ["Home", "Coupon Codes", "Notifications", "Connect Stripe", "Reports"]
    var dataSource: [[DataSourceItemProtocol]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
        let _tableView                  = UITableView()
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.whiteColor()
        _tableView.alwaysBounceVertical = true
        _tableView.separatorInset       = UIEdgeInsetsZero
        _tableView.layoutMargins        = UIEdgeInsetsZero
        _tableView.tableFooterView      = UIView()
        _tableView.estimatedRowHeight   = self.tableCellHeight
        
        _tableView.registerClass(MenuHeaderCell.self, forCellReuseIdentifier: self.menuHeaderCellIdentifier)
        _tableView.registerClass(MenuItemCell.self, forCellReuseIdentifier: self.menuItemCellIdentifier)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    private lazy var signOutButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("Sign Out", forState: .Normal)
        _button.setTitleColor(.whiteColor(), forState: .Normal) 
        _button.addTarget(self, action: #selector(MenuViewController.signOutClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        
        guard let user = SessionManager.sharedUser else {
            return
        }
        let headerViewModel = MenuHeaderViewModel(user: user, menuHeaderDelegate: self)
        dataSource.append([headerViewModel])
        
        var viewModels: [MenuItemViewModel] = []
        for menuItem in menuItems {
            viewModels.append(MenuItemViewModel(title: menuItem))
        }
        dataSource.append(viewModels)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp_updateConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view).multipliedBy(0.85)
        }
        signOutButton.snp_updateConstraints { (make) in
            make.top.equalTo(tableView.snp_bottom)
            make.leading.trailing.equalTo(view).multipliedBy(0.85)
            make.bottom.equalTo(view)
            make.height.equalTo(60)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signOutClicked(sender: UIButton) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate, window = appDelegate.window {
            SessionManager.sharedInstance.logout()
            
            let snapshot = window.snapshotViewAfterScreenUpdates(true)
            view.addSubview(snapshot)
            
            let viewController = JoinViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBarHidden = true
            
            window.rootViewController = navigationController
            
            UIView.animateWithDuration(0.5, animations: {
                snapshot.alpha = 0
                }, completion: { (success) in
                    snapshot.removeFromSuperview()
            })
        }
    }
}
extension MenuViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataItems = dataSource[section]
        
        return dataItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataItems = dataSource[indexPath.section]
        let viewModel = dataItems[indexPath.item]
        let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
        
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.swRevealViewController?.revealToggleAnimated(true)
        }
    }
}
extension MenuViewController: MenuHeaderDelegate {
    func didEditProfile() {
        guard let user = SessionManager.sharedUser else {
            return
        }
        
        let viewController = UserProfileViewController(user: user, profileType: .bull)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
}
extension MenuViewController: UserProfileDelegate {
    func didClickBack() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
