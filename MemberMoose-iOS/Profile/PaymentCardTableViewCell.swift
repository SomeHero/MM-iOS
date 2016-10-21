//
//  PaymentCardTableViewCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/16/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

protocol PaymentCardCellDelegate: class {
    func didUpdateCardClicked()
}
class PaymentCardTableViewCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var cardInfoView: UIView = {
        let _view = UIView()
        
        self.containerView.addSubview(_view)
        
        return _view
    }()
    private lazy var nameOnCardLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.cardInfoView.addSubview(_label)
        
        return _label
    }()
    private lazy var cardDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Small)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.cardInfoView.addSubview(_label)
        
        return _label
    }()
    private lazy var cardExpirationLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.Tiny)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.cardInfoView.addSubview(_label)
        
        return _label
    }()
    private lazy var updateCardButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(UIColorTheme.SecondaryFont, forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Tiny)
        _button.layer.borderColor = UIColorTheme.SecondaryFont.CGColor
        _button.layer.borderWidth = kOnePX
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(PaymentCardTableViewCell.updateCardClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    weak var paymentCardCellDelegate: PaymentCardCellDelegate?
    
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
        cardInfoView.snp_updateConstraints { (make) in
            make.top.leading.bottom.equalTo(containerView)
        }
        nameOnCardLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(cardInfoView)
            make.top.equalTo(cardInfoView)
        }
        cardDescriptionLabel.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(cardInfoView)
            make.top.equalTo(nameOnCardLabel.snp_bottom)
        }
        cardExpirationLabel.snp_updateConstraints { (make) in
            make.leading.equalTo(cardInfoView)
            make.top.equalTo(cardDescriptionLabel.snp_bottom)
            make.bottom.equalTo(cardInfoView)
        }
        updateCardButton.snp_updateConstraints { (make) in
            make.leading.greaterThanOrEqualTo(cardInfoView.snp_trailing).offset(10)
            make.centerY.equalTo(containerView)
            make.trailing.equalTo(containerView).inset(10)
        }
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func setupWith(viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? PaymentCardViewModel {
            nameOnCardLabel.text = viewModel.nameOnCard
            TextDecorator.applyTightLineHeight(toLabel: nameOnCardLabel)
            
            cardDescriptionLabel.text = viewModel.cardDescription
            TextDecorator.applyTightLineHeight(toLabel: cardDescriptionLabel)
            
            cardExpirationLabel.text = viewModel.cardExpiration
            TextDecorator.applyTightLineHeight(toLabel: cardExpirationLabel)
            
            updateCardButton.setTitle("Update Card", forState: .Normal)
        }
    }
    func updateCardClicked(sender: UIButton) {
        paymentCardCellDelegate?.didUpdateCardClicked()
    }
}