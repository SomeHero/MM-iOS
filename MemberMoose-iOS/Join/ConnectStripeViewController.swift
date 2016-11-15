//
//  ConnectStripeViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/7/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SwiftyOAuth
import SWRevealViewController
import SVProgressHUD

class ConnectStripeViewController: UIViewController {
    fileprivate lazy var provider:SwiftyOAuth.Provider = {
        let _provider = Provider.stripe(
            clientID:     kStripeConnectClientId,
            clientSecret: kStripeSecretKey,
            redirectURL:  kStripeOAuthRedirectUrl
        )
        _provider.useWebView = true
        _provider.state = "STRIPE"
        _provider.scopes = ["read_write"]
    
        return _provider
    }()
    fileprivate lazy var skipButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(.gray, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Bold(.tiny)
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.skipClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var backButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "Back"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(CreatePlanViewController.backClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var memberMoosePlusStripe: UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = UIImage(named: "MMPlusStripe")
        _imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(_imageView)
        
        return _imageView
    }()
    fileprivate lazy var introLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Regular(.small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .flatWhite()
        
        self.view.addSubview(lineView)
        
        return lineView
    }()
    fileprivate lazy var feature1: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Regular(.small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var feature2: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Regular(.small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var feature3: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Regular(.small)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var connectWithStripe: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setImage(UIImage(named: "ConnectWithStripe"), for: UIControlState())
        _button.addTarget(self, action: #selector(ConnectStripeViewController.connectStripeClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var connectLaterButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(UIColorTheme.Link, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Bold(.tiny)
        
        _button.addTarget(self, action: #selector(ConnectStripeViewController.connectLaterClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var termOfServiceLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .center
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Regular(.tiny)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Connect Stripe"
        view.backgroundColor = .white
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(PlanDetailViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        memberMoosePlusStripe.snp.updateConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        introLabel.snp.updateConstraints { (make) in
            make.top.equalTo(memberMoosePlusStripe.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        lineView.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(introLabel.snp.bottom).offset(40)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(kOnePX*2)
        }
        feature1.snp.updateConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        feature2.snp.updateConstraints { (make) in
            make.top.equalTo(feature1.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        feature3.snp.updateConstraints { (make) in
            make.top.equalTo(feature2.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
        }
        connectWithStripe.snp.updateConstraints { (make) in
            make.top.equalTo(feature3.snp.bottom).offset(40)
            make.centerX.equalTo(view)
            make.width.equalTo(262)
        }
        connectLaterButton.snp.updateConstraints { (make) in
            make.top.equalTo(connectWithStripe.snp.bottom).offset(5)
            make.centerX.equalTo(view)
        }
        termOfServiceLabel.snp.updateConstraints { (make) in
            make.top.equalTo(connectLaterButton.snp.bottom).offset(20)
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
        connectLaterButton.setTitle("I'll Connect Later", for: UIControlState())
        termOfServiceLabel.text = "By connecting your Stripe account you are agreeing to the Terms of Service"
    }
    func backClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func connectStripeClicked(_ sender: UIButton) {
        guard let user = SessionManager.sharedUser else {
            return
        }
        provider.authorize { (result: Result<Token, SwiftyOAuth.Error>) -> Void in
            switch result {
            case .success(let token):
                SVProgressHUD.show()
                
                let stripeParams: [String: AnyObject] = token.dictionary as [String: AnyObject]
                let connectStripe = ConnectStripe(userId: user.id, stripeParams: stripeParams)
                
                ApiManager.sharedInstance.connectStripe(connectStripe, success: { (response) in
                    SVProgressHUD.dismiss()
                    
                    SessionManager.sharedUser = response
                    SessionManager.persistUser()
                    
                    if let account = response.account, account.referencePlans.count > 0 {
                        let viewController = ImportPlansViewController(user: user)
                        
                        self.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        let viewController = ProfileViewController(user: user, profileType: .bull)
                        let navigationController = UINavigationController(rootViewController: viewController)
                        navigationController.isNavigationBarHidden = true
                        
                        let menuViewController = MenuViewController()
                        
                        let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
                        
                        if let delegate = UIApplication.shared.delegate as? AppDelegate {
                            delegate.swRevealViewController = swRevealViewController
                            
                            delegate.window?.rootViewController?.present(swRevealViewController!, animated: true, completion: nil)
                        }
                    }
                    
                }, failure: { [weak self] (error, errorDictionary) in
                    SVProgressHUD.dismiss()
                    
                    guard let _self = self else {
                        return
                    }
                    
                    ErrorHandler.presentErrorDialog(_self, error: error, errorDictionary: errorDictionary)
                })
            case .failure(let error):
                ErrorHandler.presentErrorDialog(self, error: error, errorDictionary: nil)
            }
        }
    }
    func connectLaterClicked(_ sender: UIButton) {
        guard let user = SessionManager.sharedUser else {
            return
        }
        let viewController = ProfileViewController(user: user, profileType: .bull)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        
        let menuViewController = MenuViewController()
        
        let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.swRevealViewController = swRevealViewController
            
            delegate.window?.rootViewController?.present(swRevealViewController!, animated: true, completion: nil)
        }
    }
}
