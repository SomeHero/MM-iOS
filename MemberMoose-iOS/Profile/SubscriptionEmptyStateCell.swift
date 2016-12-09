//
//  SubscriptionEmptyStateCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/22/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

protocol SubscriptionEmptyStateCellDelegate: class {
    func didSubscribeClicked()
}
class SubscriptionEmptyStateCell: UITableViewCell, DataSourceItemCell {
    fileprivate lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clear
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    fileprivate lazy var headerLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.Header
        _label.textAlignment = .left
        _label.font = UIFontTheme.Regular(.small)
        _label.lineBreakMode = .byWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    fileprivate lazy var subscribeButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clear
        _button.setTitleColor(UIColorTheme.SecondaryFont, for: UIControlState())
        _button.titleLabel?.font = UIFontTheme.Regular(.tiny)
        _button.layer.borderColor = UIColorTheme.SecondaryFont.cgColor
        _button.layer.borderWidth = kOnePX
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(SubscriptionEmptyStateCell.subscribeClicked(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(_button)
        
        return _button
    }()
    weak var subscriptionEmptyStateCellDelegate: SubscriptionEmptyStateCellDelegate?
    
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
    func setupWith(_ viewModel: DataSourceItemProtocol) {
        guard let viewModel = viewModel as? SubscriptionEmptyStateViewModel else {
            return
        }
        headerLabel.text = viewModel.header
        subscribeButton.setTitle("Subscribe", for: UIControlState())
    }
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.top.bottom.equalTo(contentView).inset(40)
            make.leading.equalTo(contentView).inset(20)
        }
        headerLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.leading.trailing.equalTo(containerView)
        }
        subscribeButton.snp.updateConstraints { (make) in
            make.leading.greaterThanOrEqualTo(containerView.snp.trailing).offset(10)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
        }

        super.updateConstraints()
    }
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    func subscribeClicked(_ sender: UIButton) {
        subscriptionEmptyStateCellDelegate?.didSubscribeClicked()
    }
}
