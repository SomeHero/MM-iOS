//
//  PaymentCardEmptyStateCell.swift
//  MemberMoose-iOS
//
//  Created by James Rhodes on 10/22/16.
//  Copyright © 2016 James Rhodes. All rights reserved.
//

import UIKit

class PaymentCardEmptyStateCell: UITableViewCell {
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
        _label.font = UIFontTheme.Regular(.Default)
        _label.lineBreakMode = .ByWordWrapping
        _label.numberOfLines = 0
        
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
    func setupWith(viewModel: DataSourceItemProtocol) {
        guard let viewModel = viewModel as? PaymentCardEmptyStateViewModel else {
            return
        }
        headerLabel.text = viewModel.header
    }
    override func updateConstraints() {
        containerView.snp_updateConstraints { (make) in
            make.top.bottom.equalTo(contentView).inset(40)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        headerLabel.snp_updateConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.leading.trailing.equalTo(containerView)
        }
        
        super.updateConstraints()
    }
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
}