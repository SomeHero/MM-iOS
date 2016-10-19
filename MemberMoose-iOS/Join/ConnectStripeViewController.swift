//
//  ConnectStripeViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import OAuthSwift
import SWRevealViewController

class ConnectStripeViewController: UIViewController {
    private lazy var oauthswift: OAuth2Swift = {
        let _oauth = OAuth2Swift(
            consumerKey:    kStripeConnectClientId,
            consumerSecret: kStripeSecretKey,
            authorizeUrl:   "https://connect.stripe.com/oauth/authorize",
            accessTokenUrl: "https://connect.stripe.com/oauth/token",
            responseType:   "code"
        )
        
        return _oauth
    }()
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
    private lazy var feature1: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Regular(.Small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var feature2: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Regular(.Small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var feature3: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Center
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Regular(.Small)
        
        self.view.addSubview(_label)
        
        return _label
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
        feature1.snp_updateConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        feature2.snp_updateConstraints { (make) in
            make.top.equalTo(feature1.snp_bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        feature3.snp_updateConstraints { (make) in
            make.top.equalTo(feature2.snp_bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        connectWithStripe.snp_updateConstraints { (make) in
            make.top.equalTo(feature3.snp_bottom).offset(40)
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
        feature1.text = "No monthly fees or minimums"
        feature2.text = "Built-in fraud detection & security"
        feature3.text = "Trusted by over 12,000 businesses"
        connectLaterButton.setTitle("I'll Connect Later", forState: .Normal)
        termOfServiceLabel.text = "By connecting your Stripe account you are agreeing to the Terms of Service"
    }
    func backClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func connectStripeClicked(sender: UIButton) {
        guard let user = SessionManager.sharedUser else {
            return
        }
        oauthswift.authorizeWithCallbackURL(
            NSURL(string: "http://membermoose-node.herokuapp.com/oauth-callback/stripe")!,
            scope: "read_write", state:"STRIPE",
            success: { credential, response, parameters in
                print(credential.oauth_token)
                
                let stripeParams: [String: AnyObject] = [
                    "scope": "read_write",
                    "stripe_user_id": "",
                    "stripe_publishable_key": credential.oauth_token_secret,
                    "token_type": "bearer",
                    "refresh_token": credential.oauth_refresh_token,
                    "livemode": true,
                    "access_token": credential.oauth_token
                ]
                let connectStripe = ConnectStripe(userId: user.id, stripeParams: stripeParams)
                ApiManager.sharedInstance.connectStripe(connectStripe, success: { (response) in
                    SessionManager.sharedUser = response
                    
                    let viewController = ImportPlansViewController()
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }, failure: { (error, errorDictionary) in
                    print("failed")
                })
            },
            failure: { error in
                print(error.localizedDescription)
            }
        )
    }
    func connectLaterClicked(sender: UIButton) {
        let viewController = MembersViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBarHidden = true
        
        let menuViewController = MenuViewController()
        
        let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
        
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.swRevealViewController = swRevealViewController
            
            delegate.window?.rootViewController?.presentViewController(swRevealViewController, animated: true, completion: nil)
        }
    }
}
