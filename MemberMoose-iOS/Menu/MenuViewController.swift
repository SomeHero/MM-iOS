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
    private let menuItemCellIdentifier          = "MenuItemCellIdentifier"
    private let tableCellHeight: CGFloat        = 120
    private let menuItems = ["Home", "Profile", "Coupon Codes", "Notifications", "Connect Stripe", "Reports"]
    
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
        
        //_tableView.registerClass(MenuViewController.self, forCellReuseIdentifier: self.menuItemCellIdentifier)
        
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(menuItemCellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:menuItemCellIdentifier)
        }
        cell!.textLabel?.text = menuItems[indexPath.row]
        
        return cell!
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
