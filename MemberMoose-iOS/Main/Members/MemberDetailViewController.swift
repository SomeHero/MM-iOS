//
//  MemberDetailViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/10/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import ALTextInputBar
import Kingfisher

class MemberDetailViewController: UIViewController {
    private var memberNavigationState: MemberNavigationState = .Message
    private let user: User
    private let textInputBar = ALTextInputBar()

    private lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Back-Reverse"), forState: .Normal)
        _button.addTarget(self, action: #selector(MemberDetailViewController.backClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    private lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Settings"), forState: .Normal)
        _button.addTarget(self, action: #selector(MemberDetailViewController.showProfile(_:)), forControlEvents: .TouchUpInside)
        
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
    private lazy var memberNavigation: MemberNavigationView = {
        let _view = MemberNavigationView()
        _view.delegate = self
        self.topBackgroundView.addSubview(_view)
        
        return _view
    }()
    override var inputAccessoryView: UIView? {
        get {
            switch memberNavigationState {
            case .Message:
                return textInputBar
            default:
                return nil
            }
        }
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    init(user: User) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Member Detail"
        view.backgroundColor = .whiteColor()
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(ProfileViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        memberNavigation.setSelectedButton(memberNavigationState)
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
        memberNavigation.snp_updateConstraints { (make) in
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
//                                    placeholderImage: UIImage(named: "MissingAvatar-Bull"))
//        } else {
            logo.image = UIImage(named: "Avatar-Calf")
        //}
        companyNameLabel.text = user.emailAddress
        subHeadingLabel.text = "Member Since ()"
    }
    func backClicked(button: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func showProfile(button: UIButton) {
        let viewController = ProfileViewController(user: user, profileType: .calf)
 
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBarHidden = true
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
}
extension MemberDetailViewController: MemberNavigationDelegate {
    func messageClicked() {
        memberNavigationState = .Message
        memberNavigation.setSelectedButton(memberNavigationState)
        
        reloadInputViews()
    }
    func profileClicked() {
        memberNavigationState = .Profile
        memberNavigation.setSelectedButton(memberNavigationState)
        
        reloadInputViews()
    }
    func chargeClicked() {
        memberNavigationState = .Charge
        memberNavigation.setSelectedButton(memberNavigationState)
        
        reloadInputViews()
    }
}

enum MemberNavigationState {
    case Message
    case Profile
    case Charge
}
protocol MemberNavigationDelegate: class {
    func messageClicked()
    func profileClicked()
    func chargeClicked()
}
class MemberNavigationView: UIView {
    weak var delegate: MemberNavigationDelegate?
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.messageButton, self.profileButton, self.chargeButton])
        stack.axis = .Horizontal
        stack.distribution = .EqualCentering
        stack.spacing = 10
        
        self.addSubview(stack)
        return stack
    }()
    private lazy var messageButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("MESSAGE", forState: .Normal)
        _button.addTarget(self, action: #selector(MemberNavigationView.messageClicked(_:)), forControlEvents: .TouchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.titleLabel?.textColor = .whiteColor()
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    private lazy var profileButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("PROFILE", forState: .Normal)
        _button.addTarget(self, action: #selector(MemberNavigationView.profileClicked(_:)), forControlEvents: .TouchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.titleLabel?.textColor = .whiteColor()
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    private lazy var chargeButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("CHARGE", forState: .Normal)
        _button.addTarget(self, action: #selector(MemberNavigationView.chargeClicked(_:)), forControlEvents: .TouchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.Small)
        _button.titleLabel?.textColor = .whiteColor()
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    override func updateConstraints() {
        stackView.snp_updateConstraints { (make) in
            make.edges.equalTo(self)
        }
        super.updateConstraints()
    }
    func setSelectedButton(state: MemberNavigationState) {
        clearButtonSelectedState(messageButton)
        clearButtonSelectedState(profileButton)
        clearButtonSelectedState(chargeButton)
        
        switch state {
        case .Message:
            messageButton.backgroundColor = UIColorTheme.Primary
            messageButton.layer.cornerRadius = messageButton.frame.size.height/2
        case .Profile:
            profileButton.backgroundColor = UIColorTheme.Primary
            profileButton.layer.cornerRadius = profileButton.frame.size.height/2
        case .Charge:
            chargeButton.backgroundColor = UIColorTheme.Primary
            chargeButton.layer.cornerRadius = chargeButton.frame.size.height/2
        }
    }
    private func clearButtonSelectedState(button: UIButton) {
        button.backgroundColor = .clearColor()
    }
    func messageClicked(sender: UIButton) {
        delegate?.messageClicked()
    }
    func profileClicked(sender: UIButton) {
        delegate?.profileClicked()
    }
    func chargeClicked(sender: UIButton) {
        delegate?.chargeClicked()
    }
}
