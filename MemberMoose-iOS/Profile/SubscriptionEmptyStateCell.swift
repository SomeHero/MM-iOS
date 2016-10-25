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
class SubscriptionEmptyStateCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let _view = UIView()
        
        _view.backgroundColor = .clearColor()
        
        self.contentView.addSubview(_view)
        
        return _view
    }()
    private lazy var headerLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColorTheme.Header
        _label.textAlignment = .Left
        _label.font = UIFontTheme.Regular(.Small)
        _label.lineBreakMode = .ByWordWrapping
        _label.numberOfLines = 0
        
        self.containerView.addSubview(_label)
        
        return _label
    }()
    private lazy var subscribeButton: UIButton = {
        let _button = UIButton()
        _button.backgroundColor = .clearColor()
        _button.setTitleColor(UIColorTheme.SecondaryFont, forState: .Normal)
        _button.titleLabel?.font = UIFontTheme.Regular(.Tiny)
        _button.layer.borderColor = UIColorTheme.SecondaryFont.CGColor
        _button.layer.borderWidth = kOnePX
        _button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        _button.addTarget(self, action: #selector(SubscriptionEmptyStateCell.subscribeClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.contentView.addSubview(_button)
        
        return _button
    }()
    weak var subscriptionEmptyStateCellDelegate: SubscriptionEmptyStateCellDelegate?
    
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
    func setupWith(viewModel: DataSourceItemProtocol) {
        guard let viewModel = viewModel as? SubscriptionEmptyStateViewModel else {
            return
        }
        headerLabel.text = viewModel.header
        subscribeButton.setTitle("Subscribe", forState: .Normal)
    }
    override func updateConstraints() {
        containerView.snp_updateConstraints { (make) in
            make.top.bottom.equalTo(contentView).inset(40)
            make.leading.equalTo(contentView).inset(20)
        }
        headerLabel.snp_updateConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.leading.trailing.equalTo(containerView)
        }
        subscribeButton.snp_updateConstraints { (make) in
            make.leading.greaterThanOrEqualTo(containerView.snp_trailing).offset(10)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
        }

        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    func subscribeClicked(sender: UIButton) {
        subscriptionEmptyStateCellDelegate?.didSubscribeClicked()
    }
}