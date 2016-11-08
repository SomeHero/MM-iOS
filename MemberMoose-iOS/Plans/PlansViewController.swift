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
    fileprivate var planNavigationState: PlanNavigationState = .details
    fileprivate let plan: Plan
    fileprivate let textInputBar = ALTextInputBar()
    
    fileprivate lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Back-Reverse"), for: UIControlState())
        _button.addTarget(self, action: #selector(PlanDetailViewController.backClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Settings"), for: UIControlState())
        _button.addTarget(self, action: #selector(PlanDetailViewController.showProfile(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var topBackgroundView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = UIColorTheme.TopBackgroundColor
        
        self.view.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.topBackgroundView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var logo: UIImageView = {
        let _imageView = UIImageView()
        _imageView.layer.cornerRadius = 80 / 2
        _imageView.clipsToBounds = true
        _imageView.layer.borderColor = UIColor.white.cgColor
        _imageView.layer.borderWidth = 2.0
        
        self.containerView.addSubview(_imageView)
        
        return _imageView
    }()
    fileprivate lazy var companyNameLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = .white
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.default)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var subHeadingLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.SubHeader
        _label.textAlignment = .center
        _label.font = UIFontTheme.Regular(.tiny)
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var planNavigation: PlanNavigationView = {
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
        view.backgroundColor = .white
    
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(ProfileViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        planNavigation.setSelectedButton(planNavigationState)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topBackgroundView.snp.updateConstraints { (make) in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
        }
        menuButton.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.leading.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        settingsButton.snp.updateConstraints { (make) in
            make.top.equalTo(view).inset(30)
            make.trailing.equalTo(view).inset(15)
            make.height.width.equalTo(20)
        }
        containerView.snp.updateConstraints { (make) in
            make.centerX.centerY.equalTo(topBackgroundView)
        }
        logo.snp.updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(80)
        }
        companyNameLabel.snp.updateConstraints { (make) in
            make.top.equalTo(logo.snp.bottom).offset(20)
            make.centerX.equalTo(containerView)
        }
        subHeadingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(companyNameLabel.snp.bottom)
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        planNavigation.snp.updateConstraints { (make) in
            make.top.equalTo(containerView.snp.bottom).offset(20)
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
    func backClicked(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func showProfile(_ button: UIButton) {
//        let viewController = PlanProfileViewController(plan: plan, profileType: .calf)
//        
//        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.navigationBarHidden = true
//        
//        presentViewController(navigationController, animated: true, completion: nil)
    }
}
