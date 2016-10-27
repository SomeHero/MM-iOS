//
//  PlansViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/25/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

import UIKit
import ALTextInputBar
import Kingfisher

class PlanDetailViewController: UIViewController {
    private var planNavigationState: PlanNavigationState = .Details
    private let plan: Plan
    private let textInputBar = ALTextInputBar()
    
    private lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Back-Reverse"), forState: .Normal)
        _button.addTarget(self, action: #selector(PlanDetailViewController.backClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Settings"), forState: .Normal)
        _button.addTarget(self, action: #selector(PlanDetailViewController.showProfile(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var topBackgroundView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = UIColorTheme.TopBackgroundColor
        
        self.view.addSubview(_view)
        
        return _view
    }()
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.topBackgroundView.addSubview(_view)
        
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
    private lazy var companyNameLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = .whiteColor()
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .Center
        _label.font = UIFontTheme.Regular(.Tiny)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var planNavigation: PlanNavigationView = {
        let _view = PlanNavigationView()
        //_view.delegate = self
        self.topBackgroundView.addSubview(_view)
        
        return _view
    }()
    init(plan: Plan) {
        self.plan = plan
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Plans"
        view.backgroundColor = .whiteColor()
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(ProfileViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        planNavigation.setSelectedButton(planNavigationState)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topBackgroundView.snp_updateConstraints { (make) in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
        }
        menuButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        settingsButton.snp_updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.trailing.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        containerView.snp_updateConstraints { (make) in
            make.centerX.centerY.equalTo(topBackgroundView)
        }
        logo.snp_updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(80)
        }
        companyNameLabel.snp_updateConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(20)
            make.centerX.equalTo(containerView)
        }
        subHeadingLabel.snp_updateConstraints { (make) in
            make.top.equalTo(companyNameLabel.snp_bottom)
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        planNavigation.snp_updateConstraints { (make) in
            make.top.equalTo(containerView.snp_bottom).offset(20)
            make.leading.trailing.equalTo(topBackgroundView).inset(20)
            make.bottom.equalTo(topBackgroundView).inset(20)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
//        if let avatar = user.avatar, avatarImageUrl = avatar["large"] {
//            logo.kf_setImageWithURL(NSURL(string: avatarImageUrl)!,
//                                    placeholderImage: UIImage(named: "Avatar-Calf"))
//        } else {
//            logo.image = UIImage(named: "Avatar-Calf")
//        }
//        companyNameLabel.text = user.emailAddress
//        subHeadingLabel.text = "Member Since ()"
    }
    func backClicked(button: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func showProfile(button: UIButton) {
//        let viewController = PlanProfileViewController(plan: plan, profileType: .calf)
//        
//        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.navigationBarHidden = true
//        
//        presentViewController(navigationController, animated: true, completion: nil)
    }
}
