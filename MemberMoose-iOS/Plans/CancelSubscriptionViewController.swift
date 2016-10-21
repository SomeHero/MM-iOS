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
    func didConfirmCancelSubscription(subscription: Subscription)
    func didClose()
}
class CancelSubscriptionViewController: UIViewController {
    weak var cancelSubscriptionDelegate: CancelSubscriptionDelegate?
    let subscription: Subscription
    
    lazy var outerContainerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.view.addSubview(_view)
        
        return _view
    }()
    lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .whiteColor()
        _view.layer.cornerRadius = 10.0
        _view.layer.borderColor = UIColor.grayColor().CGColor
        _view.layer.borderWidth = 0.5
        _view.clipsToBounds = true
        
        self.view.addSubview(_view)
        
        return _view
    }()
    lazy var closeButton: UIButton = {
        let _button = UIButton()
        _button.titleLabel?.font = UIFont.fontAwesomeOfSize(28)
        _button.setTitleColor(UIColorTheme.SecondaryFont, forState: .Normal)
        _button.setTitleColor(UIColorTheme.SecondaryFont, forState: .Highlighted)
        _button.setTitle(String.fontAwesomeIconWithName(FontAwesome.Remove), forState: .Normal)
        _button.backgroundColor = UIColor.clearColor()
        _button.addTarget(self, action: #selector(CancelSubscriptionViewController.closeClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    lazy var headerLabel: UILabel = {
        let _label = UILabel()
        
        _label.textColor = UIColorTheme.PrimaryFont
        _label.font = UIFontTheme.Regular(.Large)
        _label.numberOfLines = 0
        _label.textAlignment = .Center
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    lazy var descriptionLabel: UILabel = {
        let _label = UILabel()
        
        _label.textColor = UIColorTheme.PrimaryFont
        _label.font = UIFontTheme.Regular()
        _label.numberOfLines = 0
        _label.textAlignment = .Center
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    lazy var confirmationLabel: UILabel = {
        let _label = UILabel()
        
        _label.textColor = UIColorTheme.PrimaryFont
        _label.font = UIFontTheme.Regular()
        _label.numberOfLines = 0
        _label.textAlignment = .Center
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    lazy var buttonContainer: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .whiteColor()
        
        self.view.addSubview(_view)
        
        return _view
    }()
    lazy var cancelButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(UIColorTheme.Link, forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(CancelSubscriptionViewController.cancelClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.buttonContainer.addSubview(_button)
        
        return _button
    }()
    lazy var confirmButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .redColor()
        _button.setTitleColor(.whiteColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        _button.layer.cornerRadius = 5
        _button.clipsToBounds = true
        
        _button.addTarget(self, action: #selector(CancelSubscriptionViewController.confirmClicked(_:)), forControlEvents: .TouchUpInside)
        
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
        
        self.view.backgroundColor = .clearColor()
        
        outerContainerView.snp_makeConstraints { (make) in
            make.top.equalTo(view).inset(40)
            make.bottom.equalTo(view)
            make.leading.trailing.equalTo(view)
        }
        closeButton.snp_makeConstraints { (make) in
            make.top.trailing.equalTo(containerView).inset(5)
            make.width.height.equalTo(40)
        }
        containerView.snp_makeConstraints { (make) in
            make.centerY.equalTo(outerContainerView)
            make.leading.trailing.equalTo(outerContainerView)
        }
        headerLabel.snp_makeConstraints { (make) in
            make.top.equalTo(containerView).inset(40)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        descriptionLabel.snp_makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp_bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        confirmationLabel.snp_makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        buttonContainer.snp_makeConstraints { (make) in
            make.top.equalTo(confirmationLabel.snp_bottom).offset(40)
            make.centerX.equalTo(containerView)
            make.bottom.equalTo(containerView).inset(10)
        }
        cancelButton.snp_makeConstraints { (make) in
            make.leading.top.bottom.equalTo(buttonContainer)
        }
        confirmButton.snp_makeConstraints { (make) in
            make.leading.equalTo(cancelButton.snp_trailing).offset(80)
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
        cancelButton.setTitle("No, Close", forState: .Normal)
        confirmButton.setTitle("YES, CANCEL", forState: .Normal)
    }
    func cancelClicked(sender: UIButton) {
        cancelSubscriptionDelegate?.didClose()
    }
    func confirmClicked(sender: UIButton) {
        cancelSubscriptionDelegate?.didConfirmCancelSubscription(subscription)
    }
    func closeClicked(sender: UIButton) {
        cancelSubscriptionDelegate?.didClose()
    }
}
