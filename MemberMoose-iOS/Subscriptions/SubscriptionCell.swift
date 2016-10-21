//
//  SubscriptionCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

protocol SubscriptionCellDelegate: class {
    func didCancelSubscriptionClicked()
    func didChangeSubscriptionClicked()
    func didHoldSubscriptionClicked()
}
class SubscriptionCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var planAmountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var statusLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var changePlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(UIColorTheme.SecondaryFont, forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Tiny)
        _button.layer.borderColor = UIColorTheme.SecondaryFont.CGColor
        _button.layer.borderWidth = kOnePX
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(SubscriptionCell.upgradeDowngradeClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    private lazy var cancelSubscriptionButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(UIColorTheme.SecondaryFont, forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Tiny)
        _button.layer.borderColor = UIColorTheme.SecondaryFont.CGColor
        _button.layer.borderWidth = kOnePX
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(SubscriptionCell.cancelSubscriptionClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    weak var subscriptionCellDelegate: SubscriptionCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .whiteColor()
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        accessoryType = .None
        selectionStyle = .None
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    override func updateConstraints() {
        containerView.snp_updateConstraints { (make) in
            make.edges.equalTo(contentView).inset(20)
        }
        planNameLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(containerView)
        }
        planAmountLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(planNameLabel.snp_bottom)
        }
        changePlanButton.snp_updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.top.equalTo(planAmountLabel.snp_bottom).offset(10)
            make.bottom.equalTo(containerView)
        }
        cancelSubscriptionButton.snp_updateConstraints { (make) in
            make.leading.equalTo(changePlanButton.snp_trailing).offset(10)
            make.top.equalTo(planAmountLabel.snp_bottom).offset(10)
            make.bottom.equalTo(containerView)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func setupWith(viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? SubscriptionViewModel {
            planNameLabel.text = viewModel.planName
            TextDecorator.applyTightLineHeight(toLabel: planNameLabel)
            
            planAmountLabel.text = viewModel.planAmount
            TextDecorator.applyTightLineHeight(toLabel: planAmountLabel)
            
            statusLabel.text = viewModel.status
            changePlanButton.setTitle("Upgrade/Downgrade", forState: .Normal)
            cancelSubscriptionButton.setTitle("Cancel Subscription", forState: .Normal)
        }
    }
    func upgradeDowngradeClicked(sender: UIButton) {
        subscriptionCellDelegate?.didChangeSubscriptionClicked()
    }
    func cancelSubscriptionClicked(sender: UIButton) {
        subscriptionCellDelegate?.didCancelSubscriptionClicked() 
    }
}
