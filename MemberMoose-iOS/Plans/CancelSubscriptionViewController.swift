//
//  CancelSubscriptionViewController.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/20/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol CancelSubscriptionDelegate: class {
    func didConfirmCancelSubscription(_ subscription: Subscription)
    func didClose()
}
class CancelSubscriptionViewController: UIViewController {
    weak var cancelSubscriptionDelegate: CancelSubscriptionDelegate?
    let subscription: Subscription
    
    lazy var outerContainerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.view.addSubview(_view)
        
        return _view
    }()
    lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .white
        _view.layer.cornerRadius = 10.0
        _view.layer.borderColor = UIColor.gray.cgColor
        _view.layer.borderWidth = 0.5
        _view.clipsToBounds = true
        
        self.view.addSubview(_view)
        
        return _view
    }()
    lazy var closeButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFont.fontAwesome(ofSize: 28)
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: UIControlState())
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: .highlighted)
        _button.setTitle(String.fontAwesomeIcon(name: FontAwesome.remove), for: .normal)
        _button.backgroundColor = UIColor.clear
        _button.addTarget(self, action: #selector(CancelSubscriptionViewController.closeClicked(_:)), for: .touchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    lazy var headerLabel: UILabel = {
        let _label = UILabel()
        
        _label.textColor = UIColorTheme.PrimaryFont
        _label.font = UIFontTheme.Regular(.large)
        _label.numberOfLines = 0
        _label.textAlignment = .center
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    lazy var descriptionLabel: UILabel = {
        let _label = UILabel()
        
        _label.textColor = UIColorTheme.PrimaryFont
        _label.font = UIFontTheme.Regular()
        _label.numberOfLines = 0
        _label.textAlignment = .center
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    lazy var confirmationLabel: UILabel = {
        let _label = UILabel()
        
        _label.textColor = UIColorTheme.PrimaryFont
        _label.font = UIFontTheme.Regular()
        _label.numberOfLines = 0
        _label.textAlignment = .center
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    lazy var buttonContainer: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .white
        
        self.view.addSubview(_view)
        
        return _view
    }()
    lazy var cancelButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(UIColorTheme.Link, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Bold(.tiny)
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(CancelSubscriptionViewController.cancelClicked(_:)), for: .touchUpInside)
        
        self.buttonContainer.addSubview(_button)
        
        return _button
    }()
    lazy var confirmButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .red
        _button.setTitleColor(.white, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Bold(.tiny)
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        _button.layer.cornerRadius = 5
        _button.clipsToBounds = true
        
        _button.addTarget(self, action: #selector(CancelSubscriptionViewController.confirmClicked(_:)), for: .touchUpInside)
        
        self.buttonContainer.addSubview(_button)
        
        return _button
    }()
    required init(subscription: Subscription) {
        self.subscription = subscription
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        outerContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(view).inset(40)
            make.bottom.equalTo(view)
            make.leading.trailing.equalTo(view)
        }
        closeButton.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(containerView).inset(5)
            make.width.height.equalTo(40)
        }
        containerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(outerContainerView)
            make.leading.trailing.equalTo(outerContainerView)
        }
        headerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerView).inset(40)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        confirmationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        buttonContainer.snp.makeConstraints { (make) in
            make.top.equalTo(confirmationLabel.snp.bottom).offset(40)
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView).inset(10)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(buttonContainer)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.leading.equalTo(cancelButton.snp.trailing).offset(80)
            make.trailing.top.bottom.equalTo(buttonContainer)
        }
        
        setup()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        headerLabel.text = "Cancel Subscription"
        descriptionLabel.text = "You are about to cancel James Rhodes’ subscription to your plan Co-working 3 days per week.  This action can not be undone."
        confirmationLabel.text = "Are you sure?"
        cancelButton.setTitle("No, Close", for: UIControlState())
        confirmButton.setTitle("YES, CANCEL", for: UIControlState())
    }
    func cancelClicked(_ sender: UIButton) {
        cancelSubscriptionDelegate?.didClose()
    }
    func confirmClicked(_ sender: UIButton) {
        cancelSubscriptionDelegate?.didConfirmCancelSubscription(subscription)
    }
    func closeClicked(_ sender: UIButton) {
        cancelSubscriptionDelegate?.didClose()
    }
}
