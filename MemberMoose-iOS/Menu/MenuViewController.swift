//
//  MenuViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

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
        
        signOutButton.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(60)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signOutClicked(sender: UIButton) {
        SessionManager.sharedInstance.logout()
    }
}
