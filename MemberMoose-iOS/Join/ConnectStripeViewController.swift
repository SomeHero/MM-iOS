//
//  ConnectStripeViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import OAuthSwift

class ConnectStripeViewController: UIViewController {
    private lazy var skipButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(.grayColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.skipClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var backButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "Back"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(CreatePlanViewController.backClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var memberMoosePlusStripe: UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = UIImage(named: "MMPlusStripe")
        _imageView.contentMode = .ScaleAspectFit
        
        self.view.addSubview(_imageView)
        
        return _imageView
    }()
    private lazy var introLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Regular(.Small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.flatWhiteColor()
        
        self.view.addSubview(lineView)
        
        return lineView
    }()
    private lazy var connectWithStripe: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setImage(UIImage(named: "ConnectWithStripe"), forState: .Normal)
        _button.addTarget(self, action: #selector(ConnectStripeViewController.connectStripeClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var connectLaterButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(UIColorTheme.Link, forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        
        _button.addTarget(self, action: #selector(ConnectStripeViewController.connectLaterClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var termOfServiceLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Regular(.Tiny)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        setup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        skipButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.trailing.equalTo(view).inset(15)
        }
        backButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.equalTo(view).inset(15)
            make.height.equalTo(18)
        }
        titleLabel.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(35)
            make.leading.greaterThanOrEqualTo(backButton.snp_trailing).inset(10)
            //make.trailing.equalTo(leading)
            make.centerX.equalTo(view)
        }
        memberMoosePlusStripe.snp_updateConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        introLabel.snp_updateConstraints { (make) in
            make.top.equalTo(memberMoosePlusStripe.snp_bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        lineView.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(introLabel.snp_bottom).offset(40)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(kOnePX*2)
        }
        connectWithStripe.snp_updateConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom).offset(40)
            make.centerX.equalTo(view)
            make.width.equalTo(262)
        }
        connectLaterButton.snp_updateConstraints { (make) in
            make.top.equalTo(connectWithStripe.snp_bottom).offset(5)
            make.centerX.equalTo(view)
        }
        termOfServiceLabel.snp_updateConstraints { (make) in
            make.top.equalTo(connectLaterButton.snp_bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(262)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        titleLabel.text = "Connect Stripe"
        introLabel.text = "Start accepting recurring and one-time payments with MemberMoose and Stripe."
        connectLaterButton.setTitle("I'll Connect Later", forState: .Normal)
        termOfServiceLabel.text = "By connecting your Stripe account you are agreeing to the Terms of Service"
    }
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func connectStripeClicked(sender: UIButton) {
        print("Connected Stripe")
    }
    func connectLaterClicked(sender: UIButton) {
        let oauthswift = OAuth2Swift(
            consumerKey:    "ca_7DVAPFFiNfWjJn8L08FZ1Sa4unt0jxfF",
            consumerSecret: "",
            authorizeUrl:   "https://connect.stripe.com/oauth/authorize",
            responseType:   "code"
        )
        oauthswift.authorizeWithCallbackURL(
            NSURL(string: "http://membermoose-node.herokuapp.com/oauth-callback/stripe")!,
            scope: "read_write", state:"STRIPE",
            success: { credential, response, parameters in
                print(credential.oauth_token)
            },
            failure: { error in
                print(error.localizedDescription)
            }
        )
    }
}
