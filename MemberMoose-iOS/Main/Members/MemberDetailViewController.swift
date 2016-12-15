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
    fileprivate var memberNavigationState: MemberNavigationState = .message
    fileprivate let user: User
    fileprivate let textInputBar = ALTextInputBar()

    fileprivate lazy var menuButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Back-Reverse"), for: UIControlState())
        _button.addTarget(self, action: #selector(MemberDetailViewController.backClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var settingsButton: UIButton = {
        let _button = UIButton()
        _button.setImage(UIImage(named:"Settings"), for: UIControlState())
        _button.addTarget(self, action: #selector(MemberDetailViewController.showProfile(_:)), for: .touchUpInside)
        
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
    fileprivate lazy var memberNavigation: MemberNavigationView = {
        let _view = MemberNavigationView()
        _view.delegate = self
        self.topBackgroundView.addSubview(_view)
        
        return _view
    }()
    override var inputAccessoryView: UIView? {
        get {
            switch memberNavigationState {
            case .message:
                return textInputBar
            default:
                return nil
            }
        }
    }
    override var canBecomeFirstResponder : Bool {
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
        view.backgroundColor = .white
        
        let image = UIImage(named: "Back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(ProfileViewController.backClicked(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        memberNavigation.setSelectedButton(memberNavigationState)
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
        memberNavigation.snp.updateConstraints { (make) in
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
        if let avatar = user.avatar, let avatarImageUrl = avatar["large"] {
            logo.kf.setImage(with: URL(string: avatarImageUrl)!,
                                    placeholder: UIImage(named: "Avatar-Calf"))
        } else {
            logo.image = UIImage(named: "Avatar-Calf")
        }
        companyNameLabel.text = user.emailAddress
        subHeadingLabel.text = "Member Since ()"
    }
    func backClicked(_ button: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    func showProfile(_ button: UIButton) {
        let viewController = ProfileViewController(user: user, profileType: .calf)
 
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        
        present(navigationController, animated: true, completion: nil)
    }
}
extension MemberDetailViewController: MemberNavigationDelegate {
    func messageClicked() {
        memberNavigationState = .message
        memberNavigation.setSelectedButton(memberNavigationState)
        
        reloadInputViews()
    }
    func profileClicked() {
        memberNavigationState = .profile
        memberNavigation.setSelectedButton(memberNavigationState)
        
        reloadInputViews()
    }
    func chargeClicked() {
        memberNavigationState = .charge
        memberNavigation.setSelectedButton(memberNavigationState)
        
        reloadInputViews()
    }
}

enum MemberNavigationState {
    case message
    case profile
    case charge
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
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 10
        
        self.addSubview(stack)
        return stack
    }()
    fileprivate lazy var messageButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("PAYMENTS", for: UIControlState())
        _button.addTarget(self, action: #selector(MemberNavigationView.messageClicked(_:)), for: .touchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.titleLabel?.textColor = .white
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var profileButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("PROFILE", for: UIControlState())
        _button.addTarget(self, action: #selector(MemberNavigationView.profileClicked(_:)), for: .touchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.titleLabel?.textColor = .white
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var chargeButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("ACTIVITY", for: UIControlState())
        _button.addTarget(self, action: #selector(MemberNavigationView.chargeClicked(_:)), for: .touchUpInside)
        _button.titleLabel?.font = UIFontTheme.Regular(.small)
        _button.titleLabel?.textColor = .white
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.addSubview(_button)
        
        return _button
    }()
    override func updateConstraints() {
        stackView.snp.updateConstraints { (make) in
            make.edges.equalTo(self)
        }
        super.updateConstraints()
    }
    func setSelectedButton(_ state: MemberNavigationState) {
        clearButtonSelectedState(messageButton)
        clearButtonSelectedState(profileButton)
        clearButtonSelectedState(chargeButton)
        
        switch state {
        case .message:
            messageButton.backgroundColor = UIColorTheme.Primary
            messageButton.layer.cornerRadius = 40/2
        case .profile:
            profileButton.backgroundColor = UIColorTheme.Primary
            profileButton.layer.cornerRadius = 40/2
        case .charge:
            chargeButton.backgroundColor = UIColorTheme.Primary
            chargeButton.layer.cornerRadius = 40/2
        }
    }
    fileprivate func clearButtonSelectedState(_ button: UIButton) {
        button.backgroundColor = .clear
    }
    func messageClicked(_ sender: UIButton) {
        delegate?.messageClicked()
    }
    func profileClicked(_ sender: UIButton) {
        delegate?.profileClicked()
    }
    func chargeClicked(_ sender: UIButton) {
        delegate?.chargeClicked()
    }
}
