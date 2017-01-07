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
class SubscriptionCell: UITableViewCell, DataSourceItemCell {
    
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var planAmountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var statusLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColor.flatBlack()
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var changePlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.tiny)
        _button.layer.borderColor = UIColorTheme.SecondaryFont.cgColor
        _button.layer.borderWidth = kOnePX
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(SubscriptionCell.upgradeDowngradeClicked(_:)), for: .touchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var cancelSubscriptionButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.tiny)
        _button.layer.borderColor = UIColorTheme.SecondaryFont.cgColor
        _button.layer.borderWidth = kOnePX
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(SubscriptionCell.cancelSubscriptionClicked(_:)), for: .touchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    fileprivate lazy var lineView: UIView = {
        let _lineView = UIView()
        _lineView.backgroundColor = .flatWhite()
        
        self.addSubview(_lineView)
        
        return _lineView
    }()
    weak var subscriptionCellDelegate: SubscriptionCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        accessoryType = .none
        selectionStyle = .none
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.edges.equalTo(contentView).inset(20)
        }
        planNameLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(containerView)
        }
        planAmountLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(planNameLabel.snp.bottom)
        }
        changePlanButton.snp.updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.top.equalTo(planAmountLabel.snp.bottom).offset(10)
            make.bottom.equalTo(containerView)
        }
        cancelSubscriptionButton.snp.updateConstraints { (make) in
            make.leading.equalTo(changePlanButton.snp.trailing).offset(10)
            make.top.equalTo(planAmountLabel.snp.bottom).offset(10)
            make.bottom.equalTo(containerView)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(kOnePX*2)
            make.bottom.equalTo(self)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? SubscriptionViewModel {
            planNameLabel.text = viewModel.planName
            TextDecorator.applyTightLineHeight(toLabel: planNameLabel)
            
            planAmountLabel.text = viewModel.planAmount
            TextDecorator.applyTightLineHeight(toLabel: planAmountLabel)
            
            statusLabel.text = viewModel.status
            changePlanButton.setTitle("Upgrade/Downgrade", for: UIControlState())
            cancelSubscriptionButton.setTitle("Cancel", for: UIControlState())
        }
    }
    func upgradeDowngradeClicked(_ sender: UIButton) {
        subscriptionCellDelegate?.didChangeSubscriptionClicked()
    }
    func cancelSubscriptionClicked(_ sender: UIButton) {
        subscriptionCellDelegate?.didCancelSubscriptionClicked() 
    }
}
