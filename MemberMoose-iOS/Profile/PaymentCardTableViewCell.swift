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
class PaymentCardTableViewCell: UITableViewCell, DataSourceItemCell {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var cardInfoView: UIView = {
        let _view = UIView()
        
        self.containerView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var nameOnCardLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.default)
        _label.textColor = UIColorTheme.PrimaryFont
        _label.numberOfLines = 0
        
        self.cardInfoView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var cardDescriptionLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.small)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.cardInfoView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var cardExpirationLabel: UILabel = {
        let _label = UILabel()
        _label.font = UIFontTheme.Regular(.tiny)
        _label.textColor = UIColorTheme.SecondaryFont
        
        self.cardInfoView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var updateCardButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.tiny)
        _button.layer.borderColor = UIColorTheme.SecondaryFont.cgColor
        _button.layer.borderWidth = kOnePX
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(PaymentCardTableViewCell.updateCardClicked(_:)), for: .touchUpInside)
        
        self.containerView.addSubview(_button)
        
        return _button
    }()
    weak var paymentCardCellDelegate: PaymentCardCellDelegate?
    
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
        cardInfoView.snp.updateConstraints { (make) in
            make.top.leading.bottom.equalTo(containerView)
        }
        nameOnCardLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(cardInfoView)
            make.top.equalTo(cardInfoView)
        }
        cardDescriptionLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(cardInfoView)
            make.top.equalTo(nameOnCardLabel.snp.bottom)
        }
        cardExpirationLabel.snp.updateConstraints { (make) in
            make.leading.equalTo(cardInfoView)
            make.top.equalTo(cardDescriptionLabel.snp.bottom)
            make.bottom.equalTo(cardInfoView)
        }
        updateCardButton.snp.updateConstraints { (make) in
            make.leading.greaterThanOrEqualTo(cardInfoView.snp.trailing).offset(10)
            make.centerY.equalTo(containerView)
            make.trailing.equalTo(containerView).inset(10)
        }
        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        if let viewModel = viewModel as? PaymentCardViewModel {
            nameOnCardLabel.text = viewModel.nameOnCard
            TextDecorator.applyTightLineHeight(toLabel: nameOnCardLabel)
            
            cardDescriptionLabel.text = viewModel.cardDescription
            TextDecorator.applyTightLineHeight(toLabel: cardDescriptionLabel)
            
            cardExpirationLabel.text = viewModel.cardExpiration
            TextDecorator.applyTightLineHeight(toLabel: cardExpirationLabel)
            
            updateCardButton.setTitle("Update Card", for: UIControlState())
        }
    }
    func updateCardClicked(_ sender: UIButton) {
        paymentCardCellDelegate?.didUpdateCardClicked()
    }
}
