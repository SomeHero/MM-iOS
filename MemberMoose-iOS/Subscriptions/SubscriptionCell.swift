//
//  SubscriptionCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/11/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class SubscriptionCell: UITableViewCell {
    
    private lazy var planNameLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        _label.numberOfLines = 0
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    private lazy var planAmountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    private lazy var statusLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColor.flatBlackColor()
        
        self.contentView.addSubview(_label)
        
        return _label
    }()
    private lazy var changePlanButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(.grayColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        
        //_button.addTarget(self, action: #selector(CreateFirstPlanViewController.skipClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.contentView.addSubview(_button)
        
        return _button
    }()
    private lazy var cancelSubscriptionButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(.grayColor(), forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Bold(.Tiny)
        
        //_button.addTarget(self, action: #selector(CreateFirstPlanViewController.skipClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.contentView.addSubview(_button)
        
        return _button
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .whiteColor()
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        accessoryType = .None
        
        //selectedBackgroundView = selectedColorView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    func setupWith(viewModel: SubscriptionViewModel) {
        planNameLabel.text = viewModel.planName
        planAmountLabel.text = viewModel.planAmount
        statusLabel.text = viewModel.status
        changePlanButton.setTitle("Update/Downgrade Plan", forState: .Normal)
        cancelSubscriptionButton.setTitle("Cancel Subscription", forState: .Normal)
    }
    override func updateConstraints() {
        planNameLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(contentView).inset(10)
        }
        planAmountLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(planNameLabel.snp_bottom)
        }
        changePlanButton.snp_updateConstraints { (make) in
            make.leading.equalTo(contentView).inset(10)
            make.top.equalTo(planAmountLabel.snp_bottom).offset(10)
            make.bottom.equalTo(contentView).inset(10)
        }
        cancelSubscriptionButton.snp_updateConstraints { (make) in
            make.leading.equalTo(changePlanButton.snp_trailing).offset(10)
            make.top.equalTo(planAmountLabel.snp_bottom).offset(10)
            make.bottom.equalTo(contentView).inset(10)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
}
