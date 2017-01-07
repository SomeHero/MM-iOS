//
//  PaymentHistoryTableViewCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PaymentHistoryTableViewCell: UITableViewCell, DataSourceItemCell {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var transactionDateLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var transactionDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var cardDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var amountLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColorTheme.PrimaryFont
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var lineView: UIView = {
        let _lineView = UIView()
        _lineView.backgroundColor = .flatWhite()
        
        self.addSubview(_lineView)
        
        return _lineView
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
            make.top.bottom.leading.equalTo(contentView).inset(20)
        }
        transactionDateLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(containerView)
        }
        transactionDescriptionLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(containerView)
            make.top.equalTo(transactionDateLabel.snp.bottom)
        }
        cardDescriptionLabel.snp.updateConstraints { (make) in
            make.leading.equalTo(containerView)
            make.top.equalTo(transactionDescriptionLabel.snp.bottom)
            make.bottom.equalTo(containerView)
        }
        amountLabel.snp.updateConstraints { (make) in
            make.trailing.equalTo(contentView).inset(20)
            make.centerY.equalTo(contentView)
            make.leading.greaterThanOrEqualTo(containerView.snp.trailing).offset(10)
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
