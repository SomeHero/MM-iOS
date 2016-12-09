//
//  PaymentDetailsCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/26/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit
import Money

class PlanPaymentDetailsCell: UITableViewCell, DataSourceItemCell {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var signUpFeeHeaderLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold(.default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var signUpFeeLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var recurringAmountHeaderLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Bold(.default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var recurringAmountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
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
        signUpFeeHeaderLabel.snp.updateConstraints { (make) in
            make.top.equalTo(containerView)
            make.leading.trailing.equalTo(containerView)
        }
        signUpFeeLabel.snp.updateConstraints { (make) in
            make.top.equalTo(signUpFeeHeaderLabel.snp.bottom)
            make.leading.trailing.equalTo(containerView)
        }
        recurringAmountHeaderLabel.snp.updateConstraints { (make) in
            make.top.equalTo(signUpFeeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView)
        }
        recurringAmountLabel.snp.updateConstraints { (make) in
            make.top.equalTo(recurringAmountHeaderLabel.snp.bottom)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? PlanPaymentDetailsViewModel {
            signUpFeeHeaderLabel.text = viewModel.signUpFeeHeader
            TextDecorator.applyTightLineHeight(toLabel: signUpFeeHeaderLabel)
        
            signUpFeeLabel.text = viewModel.signUpFee
            
            recurringAmountHeaderLabel.text = viewModel.recurringAmountHeader
            TextDecorator.applyTightLineHeight(toLabel: recurringAmountHeaderLabel)
            
            recurringAmountLabel.text = viewModel.recurringAmount
        }
    }
}

