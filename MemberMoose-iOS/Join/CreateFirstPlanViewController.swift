//
//  CreateFirstPlanViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/6/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import SWRevealViewController

class CreateFirstPlanViewController: UIViewController {

    private lazy var skipButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(.grayColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.skipClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.Custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), forState: .Normal)
        _button.imageView?.contentMode = .ScaleAspectFit
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.nextClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var introLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Regular()
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var stripeAccountPresentHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Bold()
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var stripeAccountPresentDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Regular(.Tiny)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var importFromStripeButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true

        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.importFromStripeClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var stripeAccountNotPresentHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Bold()
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var stripeAccountNotPresentDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .Left
        _label.numberOfLines = 0
        _label.lineBreakMode = .ByWordWrapping
        _label.font = UIFontTheme.Regular(.Tiny)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    private lazy var createFirstPlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.createFirstPlanClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Getting Started"
        view.backgroundColor = .whiteColor()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = backButton

        let skipButton = UIBarButtonItem(title: "SKIP", style: UIBarButtonItemStyle.Plain, target: self, action:  #selector(CreateFirstPlanViewController.skipClicked(_:)))
        navigationItem.rightBarButtonItem = skipButton
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        introLabel.snp_updateConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        stripeAccountPresentHeadingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(introLabel.snp_bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        stripeAccountPresentDescriptionLabel.snp_updateConstraints { (make) in
            make.top.equalTo(stripeAccountPresentHeadingLabel.snp_bottom)
            make.leading.trailing.equalTo(view).inset(20)
        }
        importFromStripeButton.snp_updateConstraints { (make) in
            make.top.equalTo(stripeAccountPresentDescriptionLabel.snp_bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
        stripeAccountNotPresentHeadingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(importFromStripeButton.snp_bottom).offset(40)
            make.leading.trailing.equalTo(view).inset(20)
        }
        stripeAccountNotPresentDescriptionLabel.snp_updateConstraints { (make) in
            make.top.equalTo(stripeAccountNotPresentHeadingLabel.snp_bottom)
            make.leading.trailing.equalTo(view).inset(20)
        }
        createFirstPlanButton.snp_updateConstraints { (make) in
            make.top.equalTo(stripeAccountNotPresentDescriptionLabel.snp_bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(50)
            //make.bottom.greaterThanOrEqualTo(view).inset(60)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func setup() {
        introLabel.text = "Congrats! Your well on your way. We created your account, now we’ll help you get some data into your account."
        stripeAccountPresentHeadingLabel.text = "I have an existing Stripe account."
        stripeAccountPresentDescriptionLabel.text = "If you already have an existing Stripe account, we’ll get your started by importing your existing plans and members."
        importFromStripeButton.setTitle("Import From Stripe", forState: .Normal)
        stripeAccountNotPresentHeadingLabel.text = "I have an existing Stripe account."
        stripeAccountNotPresentDescriptionLabel.text = "If you already have an existing Stripe account, we’ll get your started by importing your existing plans and members."
        createFirstPlanButton.setTitle("Help Me Create a Plan", forState: .Normal)
    }
    func importFromStripeClicked(sender: UIButton) {
        let viewController = ConnectStripeViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func createFirstPlanClicked(sender: UIButton) {
        let viewController = PlanProfileViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func skipClicked(sender: UIButton) {
        guard let user = SessionManager.sharedUser else {
            return
        }
        let viewController = ProfileViewController(user: user, profileType: .bull)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBarHidden = true
        
        let menuViewController = MenuViewController()
        
        let swRevealViewController = SWRevealViewController(rearViewController: menuViewController, frontViewController: navigationController)
        
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.swRevealViewController = swRevealViewController
            
            delegate.window?.rootViewController?.presentViewController(swRevealViewController, animated: true, completion: nil)
        }
    }
    func nextClicked(sender: UIButton) {
        let viewController = CreatePlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
