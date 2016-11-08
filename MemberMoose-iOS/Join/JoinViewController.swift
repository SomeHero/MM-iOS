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
    fileprivate enum Copy: String {
        case SignUpText = "Sign Up from MemberMoose"
        case IntroText = "We'll walk you thru and get you up and running ASAP"
        case LoginText = "Already have an account?"
        case LoginButtonText = "Login"
    }
    fileprivate lazy var containerView: UIView = {
       let _view = UIView()
        
        self.view.addSubview(_view)
        return _view
    }()
    fileprivate lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = UIImage(named: "Logo")
        _imageView.contentMode = .scaleAspectFit
        
        self.containerView.addSubview(_imageView)
        return _imageView
    }()
    fileprivate lazy var signUpLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var introLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Regular(.small)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var nextButton: UIButton = {
       let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(JoinViewController.nextClicked(_:)), for: .touchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var loginLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.small)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var loginButton: UIButton = {
       let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(UIColorTheme.Link, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Bold(.tiny)
       
        _button.addTarget(self, action: #selector(JoinViewController.loginClicked(_:)), for: .touchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.snp.updateConstraints { (make) in
            make.centerY.equalTo(view)
            make.leading.trailing.equalTo(view)
        }
        logo.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
            make.height.equalTo(140)
        }
        signUpLabel.snp.updateConstraints { (make) in
            make.top.equalTo(logo.snp.bottom).offset(40)
            make.centerX.equalTo(containerView)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        introLabel.snp.updateConstraints { (make) in
            make.top.equalTo(signUpLabel.snp.bottom).offset(40)
            make.centerX.equalTo(containerView)
            make.leading.trailing.equalTo(containerView).inset(60)
        }
        nextButton.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(introLabel.snp.bottom).offset(60)
            make.centerX.equalTo(containerView)
            make.height.equalTo(40)
        }
        loginLabel.snp.updateConstraints { (make) in
            make.top.equalTo(nextButton.snp.bottom).offset(60)
            make.centerX.equalTo(containerView)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        loginButton.snp.updateConstraints { (make) in
            make.top.equalTo(loginLabel.snp.bottom)
            make.centerX.equalTo(containerView)
            make.leading.trailing.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView)
        }
    }
    fileprivate func setup() {
        signUpLabel.text = Copy.SignUpText.rawValue
        introLabel.text = Copy.IntroText.rawValue
        loginLabel.text = Copy.LoginText.rawValue
        loginButton.setTitle(Copy.LoginButtonText.rawValue, for: UIControlState())
    }
    func nextClicked(_ sender: UIButton) {
        let viewController = SignUpViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func loginClicked(_ sender: UIButton) {
        let viewController = LoginViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
