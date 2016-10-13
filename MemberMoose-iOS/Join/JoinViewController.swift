//
//  JoinViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SnapKit
import SWRevealViewController

class JoinViewController: UIViewController {
    private enum Copy: String {
        case SignUpText = "Sign Up from MemberMoose"
        case IntroText = "We'll walk you thru and get you up and running ASAP"
        case LoginText = "Already have an account?"
        case LoginButtonText = "Login"
    }
    private lazy var containerView: UIView = {
       let _view = UIView()
        
        self.view.addSubview(_view)
        return _view
    }()
    private lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.layer.cornerRadius = 80 / 2
        _imageView.clipsToBounds = true
        _imageView.layer.borderColor = UIColor.whiteColor().CGColor
        _imageView.layer.borderWidth = 2.0
        
        self.containerView.addSubview(_imageView)
        
        return _imageView
    }()
    private lazy var signUpLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var introLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Regular(.Small)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var nextButton: UIButton = {
       let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(JoinViewController.nextClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    private lazy var loginLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Small)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var loginButton: UIButton = {
       let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(UIColorTheme.Link, forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
       
        _button.addTarget(self, action: #selector(JoinViewController.loginClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.snp_updateConstraints { (make) in
            make.centerY.equalTo(view)
            make.leading.trailing.equalTo(view)
        }
        logo.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
            make.height.equalTo(140)
        }
        signUpLabel.snp_updateConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(40)
            make.centerX.equalTo(containerView)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        introLabel.snp_updateConstraints { (make) in
            make.top.equalTo(signUpLabel.snp_bottom).offset(40)
            make.centerX.equalTo(containerView)
            make.leading.trailing.equalTo(containerView).inset(60)
        }
        nextButton.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(introLabel.snp_bottom).offset(60)
            make.centerX.equalTo(containerView)
            make.height.equalTo(40)
        }
        loginLabel.snp_updateConstraints { (make) in
            make.top.equalTo(nextButton.snp_bottom).offset(60)
            make.centerX.equalTo(containerView)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        loginButton.snp_updateConstraints { (make) in
            make.top.equalTo(loginLabel.snp_bottom)
            make.centerX.equalTo(containerView)
            make.leading.trailing.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView)
        }
    }
    private func setup() {
        signUpLabel.text = Copy.SignUpText.rawValue
        introLabel.text = Copy.IntroText.rawValue
        loginLabel.text = Copy.LoginText.rawValue
        loginButton.setTitle(Copy.LoginButtonText.rawValue, forState: .Normal)
    }
    func nextClicked(sender: UIButton) {
        let viewController = SignUpViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func loginClicked(sender: UIButton) {
        let viewController = LoginViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
