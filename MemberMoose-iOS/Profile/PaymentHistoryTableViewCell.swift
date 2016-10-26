//
//  PaymentHistoryTableViewCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PaymentHistoryTableViewCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var transactionDateLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var transactionDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Default)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var cardDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var amountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColorTheme.PrimaryFont
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
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
            make.top.bottom.leading.equalTo(contentView).inset(20)
        }
        transactionDateLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(containerView)
        }
        transactionDescriptionLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(transactionDateLabel.snp_bottom)
        }
        cardDescriptionLabel.snp_updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.top.equalTo(transactionDescriptionLabel.snp_bottom)
            make.bottom.equalTo(containerView)
        }
        amountLabel.snp_updateConstraints { (make) in
            make.trailing.equalTo(contentView).inset(20)
            make.centerY.equalTo(contentView)
            make.leading.greaterThanOrEqualTo(containerView.snp_trailing).offset(10)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func setupWith(viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? PaymentHistoryViewModel {
            transactionDateLabel.text = viewModel.transactionDate
            TextDecorator.applyTightLineHeight(toLabel: transactionDateLabel)
            
            transactionDescriptionLabel.text = viewModel.transactionDescription
            TextDecorator.applyTightLineHeight(toLabel: transactionDescriptionLabel)
            
            cardDescriptionLabel.text = viewModel.cardDescription
            TextDecorator.applyTightLineHeight(toLabel: cardDescriptionLabel)
            
            amountLabel.text = viewModel.amount
            TextDecorator.applyTightLineHeight(toLabel: amountLabel)
        }
    }
}