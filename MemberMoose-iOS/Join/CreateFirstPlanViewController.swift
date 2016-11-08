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

    fileprivate lazy var skipButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(.gray, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Bold(.tiny)
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.skipClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var nextButton: UIButton = {
        let _button = UIButton(type: UIButtonType.custom)
        _button.setImage(UIImage(named: "RightArrow-Primary"), for: UIControlState())
        _button.imageView?.contentMode = .scaleAspectFit
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.nextClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var introLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .left
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Regular()
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var stripeAccountPresentHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .left
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Bold()
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var stripeAccountPresentDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .left
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Regular(.tiny)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var importFromStripeButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitleColor(.white, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true

        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.importFromStripeClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var stripeAccountNotPresentHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .left
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Bold()
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var stripeAccountNotPresentDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.PrimaryFont
        _label.textAlignment = .left
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = UIFontTheme.Regular(.tiny)
        
        self.view.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var createFirstPlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = UIColorTheme.Primary
        _button.setTitleColor(.white, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.layer.cornerRadius = 25
        _button.clipsToBounds = true
        
        _button.addTarget(self, action: #selector(CreateFirstPlanViewController.createFirstPlanClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Getting Started"
        view.backgroundColor = .white
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = backButton

        let skipButton = UIBarButtonItem(title: "SKIP", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(CreateFirstPlanViewController.skipClicked(_:)))
        navigationItem.rightBarButtonItem = skipButton
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        introLabel.snp.updateConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        stripeAccountPresentHeadingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(introLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        stripeAccountPresentDescriptionLabel.snp.updateConstraints { (make) in
            make.top.equalTo(stripeAccountPresentHeadingLabel.snp.bottom)
            make.leading.trailing.equalTo(view).inset(20)
        }
        importFromStripeButton.snp.updateConstraints { (make) in
            make.top.equalTo(stripeAccountPresentDescriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
        stripeAccountNotPresentHeadingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(importFromStripeButton.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view).inset(20)
        }
        stripeAccountNotPresentDescriptionLabel.snp.updateConstraints { (make) in
            make.top.equalTo(stripeAccountNotPresentHeadingLabel.snp.bottom)
            make.leading.trailing.equalTo(view).inset(20)
        }
        createFirstPlanButton.snp.updateConstraints { (make) in
            make.top.equalTo(stripeAccountNotPresentDescriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(50)
            //make.bottom.greaterThanOrEqualTo(view).inset(60)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func setup() {
        introLabel.text = "Congrats! Your well on your way. We created your account, now we’ll help you get some data into your account."
        stripeAccountPresentHeadingLabel.text = "I have an existing Stripe account."
        stripeAccountPresentDescriptionLabel.text = "If you already have an existing Stripe account, we’ll get your started by importing your existing plans and members."
        importFromStripeButton.setTitle("Import From Stripe", for: UIControlState())
        stripeAccountNotPresentHeadingLabel.text = "I have an existing Stripe account."
        stripeAccountNotPresentDescriptionLabel.text = "If you already have an existing Stripe account, we’ll get your started by importing your existing plans and members."
        createFirstPlanButton.setTitle("Help Me Create a Plan", for: UIControlState())
    }
    func importFromStripeClicked(_ sender: UIButton) {
        let viewController = ConnectStripeViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    func createFirstPlanClicked(_ sender: UIButton) {
//        let viewController = PlanProfileViewController()
//        
//        navigationController?.pushViewController(viewController, animated: true)
    }
    func skipClicked(_ sender: UIButton) {
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
    func nextClicked(_ sender: UIButton) {
        let viewController = CreatePlanViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
