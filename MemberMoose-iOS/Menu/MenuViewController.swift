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
    fileprivate let menuHeaderCellIdentifier        = "MenuHeaderCellIdentifier"
    fileprivate let menuItemCellIdentifier          = "MenuItemCellIdentifier"
    fileprivate let tableCellHeight: CGFloat        = 120
    fileprivate let menuItems = ["Home", "My Subscriptions", "Payment Card", "Payment History", "Coupon Codes", "Notifications", "Connect Stripe", "Reports"]
    var dataSource: [[DataSourceItemProtocol]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    fileprivate lazy var tableView: UITableView = {
        let _tableView                  = UITableView()
        _tableView.dataSource           = self
        _tableView.delegate             = self
        _tableView.backgroundColor      = UIColor.white
        _tableView.alwaysBounceVertical = true
        _tableView.separatorInset       = UIEdgeInsets.zero
        _tableView.layoutMargins        = UIEdgeInsets.zero
        _tableView.tableFooterView      = UIView()
        _tableView.estimatedRowHeight   = self.tableCellHeight
        
        _tableView.register(MenuHeaderCell.self, forCellReuseIdentifier: self.menuHeaderCellIdentifier)
        _tableView.register(MenuItemCell.self, forCellReuseIdentifier: self.menuItemCellIdentifier)
        
        self.view.addSubview(_tableView)
        return _tableView
    }()
    fileprivate lazy var signOutButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitle("Sign Out", for: UIControlState())
        _button.setTitleColor(.white, for: UIControlState()) 
        _button.addTarget(self, action: #selector(MenuViewController.signOutClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
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
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view).multipliedBy(0.85)
        }
        signOutButton.snp.updateConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.equalTo(view).multipliedBy(0.85)
            make.bottom.equalTo(view)
            make.height.equalTo(60)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signOutClicked(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window {
            SessionManager.sharedInstance.logout()
            
            let snapshot = window.snapshotView(afterScreenUpdates: true)
            view.addSubview(snapshot!)
            
            let viewController = JoinViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.isNavigationBarHidden = true
            
            window.rootViewController = navigationController
            
            UIView.animate(withDuration: 0.5, animations: {
                snapshot?.alpha = 0
                }, completion: { (success) in
                    snapshot?.removeFromSuperview()
            })
        }
    }
}
extension MenuViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataItems = dataSource[section]
        
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataItems = dataSource[(indexPath as NSIndexPath).section]
        let viewModel = dataItems[(indexPath as NSIndexPath).item]
        let cell = viewModel.dequeueAndConfigure(tableView, indexPath: indexPath)
        
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.swRevealViewController?.revealToggle(animated: true)
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
        
        present(viewController, animated: true, completion: nil)
    }
}
extension MenuViewController: UserProfileDelegate {
    func didClickBack() {
        dismiss(animated: true, completion: nil)
    }
}
